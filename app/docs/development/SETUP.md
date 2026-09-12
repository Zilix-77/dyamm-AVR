# Dev Setup — Status: Partially verified

## Verified environment

- Flutter 3.44.2 · Dart 3.12.2 (`flutter --version`, verified).
- Android SDK: `%LOCALAPPDATA%\Android\sdk` (via `local.properties`).
- NDK 28.2.13676358 + CMake 3.22.1 installed under the SDK (verified by listing).
- `flutter pub get` + `flutter analyze` + `flutter test` pass in `app/` (verified).

## Missing / TBD

- `avr-gcc` not on PATH — required in Phase 1 (test firmware builds). Install: TBD.
- Emulator/device used for on-device runs: TBD.
- JDK/Gradle versions: as installed by Flutter toolchain; pin down if builds break.
