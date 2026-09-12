# SimAVR — Development Roadmap

> Authoritative build order. The PRD (`prd.md` §§44, 58–59, 67) describes an older
> engines-first order; that is superseded by this file. PRD product requirements
> still apply — only the build order changed.
>
> Principle: SimAVR is a **project-based engineering environment**. The simulator is
> the engine underneath the application. User flow:
> Launch App → Project Manager → New/Open Project → Main Editor → Build/Edit/Simulate.
>
> Reordered: the ATmega32 emulator comes first (it validates the native foundation),
> the application UI layers follow.

## PHASE 0 — App Foundation ✅ complete
- [x] Initialize project structure
- [x] Configure Flutter + Dart + Riverpod
- [x] Verify Android build
- [x] Project Manager → Editor flow (in-memory session)
- [x] Schematic editor shell
- [x] Tests + debug APK

## PHASE 1 — ATmega32 Emulator on Android ✅ complete (with caveat)
- [x] Native bridge: JNI + CMake + NDK wiring
- [x] Vendor minimal simavr subset (core + ATmega32)
- [x] HEX firmware loading (ELF strategy: Phase 2 prep)
- [x] Run cycles, reset behavior
- [x] GPIO state observation
- [x] Registers, PC/SP/SREG, Flash, SRAM, EEPROM via simavr core
- [ ] Timers, interrupts: compiled in, dedicated exercise is follow-up
- [x] On-device test: known HEX toggles GPIO (PASS ×5, TEMP screen since removed)
- [x] Done when: known HEX runs, GPIO observed on device

## PHASE 2 — AVR-GCC Firmware Pipeline (prep: research only, no implementation yet)
- [x] Prep: exec-policy route, canadian-cross requirement, size/ABI + licensing notes
- [ ] Spike: `avr-gcc --version` + blink compile on-device from `nativeLibraryDir`
- [ ] Package: toolchain as `lib/*.so` entries per ABI (arm64 first)
- [ ] `Toolchain` MethodChannel + build panel + error formats
- [ ] avr-libc headers/libs, APK-size tracking, GPL source offer

## PHASE 3 — Main Editor UI
- [ ] Canvas editing, component placement/movement
- [ ] Component library interactions
- [ ] Tool pad actions, panels/dock, minimap

## PHASE 3 — Main Editor UI
- [ ] Canvas editing, component placement/movement
- [ ] Component library interactions
- [ ] Tool pad actions, panels/dock, minimap

## PHASE 4 — Project System
- [ ] `.dyamm` format, save/open/restore, validation

## PHASE 5 — MCU ↔ Digital Circuit Bridge
- [ ] GPIO ↔ LED/button, pin mapping, propagation

## PHASE 6 — Circuit Simulation Engine
- [ ] Solver selection + R/C/L/diode/LED + measurement

## PHASE 7 — Analog MCU ↔ Circuit Bridge
- [ ] ADC, PWM, sensors

## PHASE 8 — Full Component System
- [ ] Displays, motors, logic ICs, more MCUs

## PHASE 9 — Polish / Performance / Testing
- [ ] Profile, optimize, crash handling, low-end + large-circuit tests

## PHASE 10 — Release
- [ ] Icon, screenshots, notes, QA, release build
