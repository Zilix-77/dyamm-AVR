/* JNI bridge for the vendored simavr subset (Phase 1, HEX-first).
 *
 * Mirrors upstream run_avr.c (init â†’ load â†’ run â†’ terminate) minus CLI, gdb
 * server and VCD. Three deliberate deviations from upstream helpers:
 *  - sim_setup_firmware() is NOT used: it calls exit() on failure, which would
 *    kill the app process. Firmware is loaded via read_ihex_file() + a manual
 *    FLASH chunk, with error codes returned to Dart instead.
 *  - read_ihex_file() dereferences a NULL chunk list on unreadable input
 *    (upstream), so callers must pre-check readability (done here via fopen).
 *  - read_ihex_file() returns the FIRST chunk only: multi-region HEX files
 *    load their first region and ignore the rest. Single-region firmware only
 *    until the ELF strategy lands.
 * Methods are registered in JNI_OnLoad to avoid mangled-name fragility.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <jni.h>

#include "sim_avr.h"
#include "sim_elf.h"
#include "sim_hex.h"
#include "avr_ioport.h"

#define MCU_NAME "atmega32"
#define F_CPU_HZ 8000000UL

/* Portable handle discipline: avr_t* must round-trip through jlong on every
 * ABI (arm64, armv7, x86_64) without truncation. Fails the build, not the app. */
_Static_assert(sizeof(void *) <= sizeof(jlong),
	"pointer does not fit in jlong on this ABI");
_Static_assert(sizeof(void *) == sizeof(intptr_t),
	"intptr_t cannot carry pointers on this ABI");

static avr_t * handle_to_avr(jlong h)
{
	return (avr_t *)(intptr_t)h;
}

/* PORTB packed as (pin << 16) | (ddr << 8) | port. Negative on error. */
static jint read_port_b(avr_t * avr)
{
	avr_ioport_state_t state;
	memset(&state, 0, sizeof(state));
	if (avr_ioctl(avr, AVR_IOCTL_IOPORT_GETSTATE('B'), &state) != 0)
		return -1;
	return (jint)((state.pin << 16) | (state.ddr << 8) | state.port);
}

static jlong native_init(JNIEnv * env, jclass clazz)
{
	(void)env;
	(void)clazz;
	avr_t * avr = avr_make_mcu_by_name(MCU_NAME);
	if (!avr)
		return 0;
	avr_init(avr);
	return (jlong)(intptr_t)avr;
}

/* Wraps raw binary [data,size) at flash offset start into a single FLASH
 * chunk and loads it. avr_load_firmware memcpys chunk data (do_chunk), so the
 * list is ours to free. Returns 0 or a negative code. */
static jint
load_bytes(avr_t * avr, const uint8_t * data, uint32_t size, uint32_t start)
{
	fw_chunk_t * chunk;
	elf_firmware_t fw;

	if (!avr || !data || !size)
		return -3;
	chunk = (fw_chunk_t *)malloc(sizeof(fw_chunk_t) + size);
	if (!chunk)
		return -4;
	chunk->type = FLASH;
	chunk->addr = start;
	chunk->size = chunk->fill_size = size;
	chunk->next = NULL;
	memcpy(chunk->data, data, size);

	memset(&fw, 0, sizeof(fw));
	strncpy(fw.mmcu, MCU_NAME, sizeof(fw.mmcu) - 1);
	fw.frequency = F_CPU_HZ;
	fw.chunks = chunk;
	avr_load_firmware(avr, &fw);
	free(chunk);
	return 0;
}

static jint native_load_hex(JNIEnv * env, jclass clazz, jlong h, jstring path)
{
	(void)clazz;
	avr_t * avr = handle_to_avr(h);
	if (!avr || !path)
		return -1;
	const char * cpath = (*env)->GetStringUTFChars(env, path, NULL);
	if (!cpath)
		return -1;

	FILE * probe = fopen(cpath, "r");
	if (!probe) {
		(*env)->ReleaseStringUTFChars(env, path, cpath);
		return -2; // unreadable file (read_ihex_file would crash; see above)
	}
	fclose(probe);

	uint32_t size = 0, start = 0;
	uint8_t * data = read_ihex_file(cpath, &size, &start);
	(*env)->ReleaseStringUTFChars(env, path, cpath);
	if (!data || !size)
		return -3;
	jint rc = load_bytes(avr, data, size, start);
	free(data);
	return rc;
}

/* Byte-array variant: raw flash binary, no filesystem staging, no path
 * parsing. Used by the Phase 1 self-test (and any future in-memory loads). */
static jint native_load_hex_bytes(JNIEnv * env, jclass clazz, jlong h,
		jbyteArray bytes)
{
	(void)clazz;
	avr_t * avr = handle_to_avr(h);
	if (!avr || !bytes)
		return -1;
	jsize len = (*env)->GetArrayLength(env, bytes);
	if (len <= 0 || len > 1024 * 1024)
		return -3;
	uint8_t * data = (uint8_t *)malloc((size_t)len);
	if (!data)
		return -4;
	(*env)->GetByteArrayRegion(env, bytes, 0, len, (jbyte *)data);
	jint rc = load_bytes(avr, data, (uint32_t)len, 0);
	free(data);
	return rc;
}

static jint native_run_cycles(JNIEnv * env, jclass clazz, jlong h, jlong n)
{
	(void)env;
	(void)clazz;
	avr_t * avr = handle_to_avr(h);
	if (!avr || n <= 0)
		return -1;
	int state = 0;
	for (int64_t i = 0; i < n; i++) {
		state = avr_run(avr);
		if (state == cpu_Done || state == cpu_Crashed)
			break;
	}
	return state;
}

static jint native_get_port_b(JNIEnv * env, jclass clazz, jlong h)
{
	(void)env;
	(void)clazz;
	avr_t * avr = handle_to_avr(h);
	if (!avr)
		return -1;
	return read_port_b(avr);
}

static void native_terminate(JNIEnv * env, jclass clazz, jlong h)
{
	(void)env;
	(void)clazz;
	avr_t * avr = handle_to_avr(h);
	if (avr)
		avr_terminate(avr);
	// Note: avr_terminate does not free avr (same as upstream run_avr).
}

static const JNINativeMethod kMethods[] = {
	{ "nativeInit", "()J", (void *)native_init },
	{ "nativeLoadHex", "(JLjava/lang/String;)I", (void *)native_load_hex },
	{ "nativeLoadHexBytes", "(J[B)I", (void *)native_load_hex_bytes },
	{ "nativeRunCycles", "(JJ)I", (void *)native_run_cycles },
	{ "nativeGetPortB", "(J)I", (void *)native_get_port_b },
	{ "nativeTerminate", "(J)V", (void *)native_terminate },
};

JNIEXPORT jint JNICALL
JNI_OnLoad(JavaVM * vm, void * reserved)
{
	(void)reserved;
	JNIEnv * env = NULL;
	if ((*vm)->GetEnv(vm, (void **)&env, JNI_VERSION_1_6) != JNI_OK)
		return JNI_ERR;
	jclass clazz = (*env)->FindClass(
		env, "com/dyamm/dyamm_avr_schema_design/SimavrNative");
	if (!clazz)
		return JNI_ERR;
	if ((*env)->RegisterNatives(env, clazz, kMethods,
			sizeof(kMethods) / sizeof(kMethods[0])) != 0)
		return JNI_ERR;
	return JNI_VERSION_1_6;
}
