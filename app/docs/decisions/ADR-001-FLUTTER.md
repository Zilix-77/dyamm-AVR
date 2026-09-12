# ADR-001: Flutter for the application layer

- Status: Accepted
- Date: 2026-09-12
- Context: Need one codebase for an Android engineering workspace (canvas, panels,
  project system) with a path to efficient native simulation underneath.
- Decision: Flutter (Dart) for all UI + application logic; state via `flutter_riverpod`
  (`NotifierProvider` per feature manager).
- Consequences: Android-first via `app/android/`; native engines behind `lib/bridge/`
  so UI never touches FFI/channels directly.
