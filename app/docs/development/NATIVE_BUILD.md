# Native Build — Status: Planned (Phase 3–4)

> Per `AGENTS.md`: documents only verified implementation. No native code exists yet.

## Plan

- NDK 28.2.13676358 + CMake 3.22.1 (installed, verified by listing SDK dirs).
- simavr subset compiled as a static lib; exclude `sim_gdb.c`, `sim_dwarf.c`; VCD optional.
- Upstream Makefiles are POSIX-only — a dedicated `CMakeLists.txt` is required for Android.
- JNI entry points: init / loadFirmware / runCycles / getGpio / terminate (names TBD at implementation).

## To Be Verified

CMake file, compiler flags, ABI splits, `.so` size. Documented when built.
