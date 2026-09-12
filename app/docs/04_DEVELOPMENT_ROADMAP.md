# Development Roadmap (authoritative order)

> Source: product requirements in PRD; order defined here, superseding PRD §§44, 58–59, 67.
> Principle: SimAVR is a **project-based engineering environment** — the simulator is the
> engine underneath the application. User flow: Launch → Project Manager → New/Open
> Project → Main Editor → Build/Edit/Simulate.

| Phase | Goal | Done when |
|---|---|---|
| 0 App Foundation | Flutter shell, Android build, Git | App launches on device |
| 1 Main Editor UI | Project Manager (New/Open/Recent), shell, canvas, library, tool pad, panels, sim controls (unwired) | Editor usable without engine |
| 2 Project System | `.dyamm` save/open/restore, schematic + firmware + config persistence | Round-trip project on device |
| 3 Native foundation | `lib/bridge/`, `native/` C++, NDK + CMake, round-trip call | Native call returns on device |
| 4 ATmega32 + simavr | Minimal simavr subset, ELF loading, GPIO observed | Known ELF toggles GPIO on-device |
| 5 AVR-GCC pipeline | On-device compile → ELF/HEX, error panel | On-device compile + run |
| 6 Digital bridge | GPIO ↔ digital components (LED, button) | MVP circuit responds |
| 7 Circuit solver | Network sim, R/C/L/diode/LED, measurement | Voltages/currents correct |
| 8 Analog bridge | ADC, PWM, sensors | Analog loop works |
| 9 Components | Displays, motors, logic ICs, more MCUs | Per PRD §§26/55 |
| 10 Polish/perf/test | Profile, optimize, crash handling, low-end + large-circuit tests | Release criteria met |
| 11 Release | Icon, screenshots, notes, QA, build | Released |

Engines (Phases 3+) are built **underneath** the application foundation (Phases 0–2),
not before it.

## Status

Phase 0 complete: PM-first launch, in-memory session (create/open/close + validation),
editor shell (drawer, zoom controls, minimap placeholder), `flutter analyze` clean,
7/7 tests pass, debug APK builds. Native/FFI/MethodChannel boundaries are Phase 3 scope,
not Phase 0 exit criteria. Next: Phase 1 Main Editor UI.
