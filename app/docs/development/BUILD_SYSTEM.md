# Build System — Status: Planned (Phase 3)

> Per `AGENTS.md`: documents only verified implementation. No native build exists yet.

## Current (verified)

- Standard Flutter Gradle build: AGP 9.0.1, Kotlin 2.3.20,
  `namespace/applicationId com.dyamm.dyamm_avr_schema_design`.
- No `externalNativeBuild`, no `cpp/`, no Dart FFI/MethodChannel usage
  (only stub interfaces in `lib/bridge/`).

## Planned (Phase 3)

- `app/android/app/src/main/cpp/` + `CMakeLists.txt`, wired via `externalNativeBuild`.
- Vendored simavr subset copied at implementation time (Phase 4).

## To Be Verified

Actual Gradle/CMake snippets and build commands. Documented when run.
