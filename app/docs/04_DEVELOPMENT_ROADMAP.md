# Development Roadmap (authoritative order)

> Source: product requirements in PRD; order defined here, superseding PRD §§44, 58–59, 67.
> Principle: SimAVR is a **project-based engineering environment** — the simulator is the
> engine underneath the application. User flow: Launch → Project Manager → New/Open
> Project → Main Editor → Build/Edit/Simulate.
>
> Reordered: the emulator (Phase 1) validates the native foundation; AVR-GCC
> (Phase 2) follows so firmware can be built on-device before the UI layers.

| Phase | Goal | Done when |
|---|---|---|
| 0 App Foundation ✅ | Flutter shell, PM → Editor, Android build | Complete |
| 1 ATmega32 emulator ✅ | JNI/CMake/NDK, simavr subset, HEX load, GPIO observed | Known HEX toggled GPIO on-device (PASS ×5) |
| 2 AVR-GCC pipeline | Prep (research only) → on-device compile → ELF/HEX, error panel | On-device compile + run |
| 3 Main Editor UI | Canvas editing, library interactions, tool pad, panels, minimap | Editor usable without engine |
| 4 Project System | `.dyamm` save/open/restore, persistence | Round-trip project on device |
| 5 Digital bridge | GPIO ↔ digital components (LED, button) | MVP circuit responds |
| 6 Circuit solver | Network sim, R/C/L/diode/LED, measurement | Voltages/currents correct |
| 7 Analog bridge | ADC, PWM, sensors | Analog loop works |
| 8 Components | Displays, motors, logic ICs, more MCUs | Per PRD §§26/55 |
| 9 Polish/perf/test | Profile, optimize, crash handling, device tests | Release criteria met |
| 10 Release | Icon, screenshots, notes, QA, build | Released |

## Status

Phase 0 complete. Phase 1 complete with caveat: core/run/GPIO verified on-device
(PASS ×5, TEMP screen since removed); timers/interrupts compiled in, dedicated
exercise is follow-up. Editor + DC solver + file persistence implemented and
tested (31/31 flutter tests): place/select/move/delete/rotate/wire, switch
toggle, save/open `.dyamm` on disk, live LED states, solver error banner.
Phase 2 prep: Spike A PASS — exec-from-nativeLibraryDir
verified on-device (exit 0, token returned); Arduino-based cross-build plan next.
Phases 3+ remain Planned.
