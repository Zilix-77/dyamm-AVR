# SimAVR — Development Roadmap

> Authoritative build order. The PRD (`prd.md` §§44, 58–59, 67) describes an older
> engines-first order; that is superseded by this file. PRD product requirements
> still apply — only the build order changed.
>
> Principle: SimAVR is a **project-based engineering environment**. The simulator is
> the engine underneath the application. User flow:
> Launch App → Project Manager → New/Open Project → Main Editor → Build/Edit/Simulate.

## PHASE 0 — App Foundation
- [ ] Initialize project structure
- [ ] Configure Flutter + Dart + Riverpod
- [ ] Verify Android build
- [ ] Create initial app shell
- [ ] Set up Git repository

## PHASE 1 — Main Editor UI
- [ ] Project Manager: New / Open / Recent projects
- [ ] Main application shell (top bar, panels)
- [ ] Schematic canvas (pan, zoom, grid)
- [ ] Component library UI (search, categories)
- [ ] 3×3 contextual tool pad
- [ ] Movable/resizable/collapsible panels
- [ ] Simulation controls (run/pause/stop UI, unwired)

## PHASE 2 — Project System
- [ ] Design project file format (`.dyamm`)
- [ ] Save / open / restore projects
- [ ] Schematic data persistence
- [ ] Firmware/source files in project
- [ ] Project configuration
- [ ] Validate project files, handle corruption

## PHASE 3 — Native Engine Foundation
- [ ] Flutter ↔ native bridge (`lib/bridge/`)
- [ ] C++ module layout (`native/`)
- [ ] Android NDK + CMake wiring
- [ ] Verify native call round-trip on device

## PHASE 4 — ATmega32 + simavr
- [ ] Vendor minimal simavr subset (core + ATmega32, no gdb/dwarf)
- [ ] ATmega32 emulation on Android
- [ ] Firmware ELF loading (libelf strategy TBD — HEX stepping stone acceptable)
- [ ] GPIO/peripheral state observation
- [ ] Success: known ELF runs, GPIO toggles on-device

## PHASE 5 — AVR-GCC Firmware Pipeline
- [ ] AVR-GCC + AVR-Libc + binutils on Android
- [ ] C firmware compilation, ELF output, HEX export
- [ ] Compiler error reporting in build panel
- [ ] Test on-device compilation

## PHASE 6 — MCU ↔ Digital Circuit Bridge
- [ ] ATmega32 GPIO ↔ digital circuit components
- [ ] Pin-to-node mapping, HIGH/LOW propagation
- [ ] Input detection, direction handling
- [ ] Test LED + GPIO, button + GPIO

## PHASE 7 — Circuit Simulation Engine
- [ ] Electrical network simulation (solver selection TBD)
- [ ] Resistors, capacitors, inductors, diodes, LEDs, etc.
- [ ] Voltage/current measurement

## PHASE 8 — Analog MCU ↔ Circuit Bridge
- [ ] ADC, PWM, sensors, analog signals

## PHASE 9 — Full Component System
- [ ] Expanded library: displays, motors, logic ICs, comms
- [ ] Additional MCUs behind `McuInterface`

## PHASE 10 — Polish / Performance / Testing
- [ ] Profile and optimize sim loop, memory, binary size
- [ ] Crash handling, low-end device testing, large circuits

## PHASE 11 — Release
- [ ] App icon, screenshots, release notes, final QA, release build
