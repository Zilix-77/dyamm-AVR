package com.dyamm.dyamm_avr_schema_design

// JNI entry points (registered in JNI_OnLoad, see cpp/simavr_jni.c).
// Loaded lazily on first use so a missing .so never breaks app startup.
internal object SimavrNative {
    @Volatile private var loaded = false

    private fun ensureLoaded(): Boolean {
        if (loaded) return true
        return try {
            System.loadLibrary("simavr_jni")
            loaded = true
            true
        } catch (e: UnsatisfiedLinkError) {
            false
        }
    }

    fun isAvailable(): Boolean = ensureLoaded()

    external fun nativeInit(): Long
    external fun nativeLoadHex(handle: Long, path: String): Int
    external fun nativeLoadHexBytes(handle: Long, bytes: ByteArray): Int
    external fun nativeRunCycles(handle: Long, cycles: Long): Int
    external fun nativeGetPortB(handle: Long): Int
    external fun nativeTerminate(handle: Long)

    fun init(): Long = if (ensureLoaded()) nativeInit() else 0L
}
