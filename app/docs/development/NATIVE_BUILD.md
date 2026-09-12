# Native Build — Status: In progress (Phase 1)

> Per `AGENTS.md`: documents only verified implementation. No native code exists yet.

## Implemented (Phase 1)

- `android/app/src/main/cpp/CMakeLists.txt` (min 3.22.1): `simavr_jni` shared lib,
  explicit source list, no `-DHAVE_LIBELF`, links `log` + `m`.
- Wired via `externalNativeBuild` in `app/build.gradle.kts` (cmake 3.22.1).
- Two upstream-build findings recorded: no `AVR_CORE` define (breaks `sim_avr.h`
  logger typedef); `cores/sim_megax.c` required at link (`mx_init`/`mx_reset`).
- `assembleDebug` verified: 32 TUs compile, `libsimavr_jni.so` links.

## Executable packaging (Spike A, Phase 2 prep)

- Binaries executed on-device must ship as `lib/<abi>/lib*.so` and extract with
  `packaging.jniLibs.useLegacyPackaging = true` (AGP 9 rejects the manifest attr).
- Verified: NDK-built PIE hello exec'd from `nativeLibraryDir`, exit 0, targetSdk 36.
