# AVR-GCC Pipeline — Status: Prep (Phase 2, research only)

> Per `AGENTS.md`: documents only verified implementation. Nothing here is implemented yet.

## Plan

- AVR-GCC + AVR Libc + binutils packaged for Android (Phase 2; biggest risk §62.1).
- `C sources → objects → linker → ELF` (primary) → `avr-objcopy → HEX` (export).
- MVP config: `MCU atmega32 · 16 MHz · -Os` (`BuildConfig` in `lib/features/firmware/`).
- Imports treated as untrusted: sandboxed FS, restricted binaries/args (PRD §52).

## Prep findings (research only, nothing built)

- **Exec policy (central blocker):** Android 10+ forbids executing binaries from the
  app home/data dir (W^X + SELinux; our targetSdk is current). Documented route used
  by Termux and others: ship compiler binaries as `lib/*.so` entries in the APK and
  exec them from `nativeLibraryDir` with `android:extractNativeLibs="true"`.
  No workaround outside this route is planned (targetSdk downgrade rejected).
- **Toolchain build:** no prebuilt avr-gcc hosted on Android exists (checked public
  sources). Required: Canadian-cross build (build=x86_64-linux, host=Android ABI,
  target=avr) of binutils + GCC + avr-libc from Microchip/upstream sources, built
  with NDK Clang on a Linux host. Components: `avr-gcc`, `cc1`, `as`, `ld`,
  `avr-objcopy`, avr-libc headers/libs.
- **Size/ABI:** compiler set is tens of MB per ABI; start arm64-only, add armeabi-v7a
  /x86_64 when measured. Track APK growth as a release criterion.
- **Licensing (PRD §62.5):** redistributing GCC/binutils binaries triggers GPL source
  obligations — source offer + license texts must ship before any release build.
- **Rejected:** cloud compile (violates offline-first); in-process compilation
  (GCC cannot run in-process — exec is mandatory).

## Spike A result: PASS (verified on-device)

- NDK Clang built a PIE `hello` binary, staged as `jniLibs/arm64-v8a/libspike_hello.so`
  via `native/compiler/spike/build_spike_hello.ps1` (script committed; staged binary not).
- AGP 9 rejects manifest `extractNativeLibs`; the working setting is
  `packaging.jniLibs.useLegacyPackaging = true` in `app/build.gradle.kts`.
- Verified extracted at `<app>/lib/arm64/libspike_hello.so`; `ProcessBuilder` exec
  returned exit=0 + `spike-hello-ok` on vivo arm64, targetSdk 36 (TEMP screen, since removed).
- Conclusion: the `nativeLibraryDir` exec route works. Proceed to the Arduino-based
  cross-build plan.
- Cleanup done: TEMP screen/button/channel case and staged binary removed;
  `native/compiler/spike/{hello.c,build_spike_hello.ps1}` retained as the
  reproducible proof.

## To Be Verified

Packaging approach, binaries, build commands, on-device compile times, error formats.
Documented when tested. See also `../architecture/FIRMWARE_PIPELINE.md`.
