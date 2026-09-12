# Tech Stack

> Source: PRD §10.

| Layer | Choice |
|---|---|
| UI / language | Flutter / Dart |
| State | `flutter_riverpod` (Notifier per feature manager) |
| Native sim | C++ via Android NDK + CMake |
| AVR emulator | dyamm-AVR (behind `AvrEngine` interface, swappable — §16) |
| Compiler | AVR-GCC + AVR Libc → **ELF** primary, HEX via `avr-objcopy` |
| Circuit solver | **Undecided** — RSpice / ngspice candidate, benchmark on Android (§13) |
| Flutter↔native | FFI (solver/AVR/bridge hot loop) + MethodChannel (toolchain) |
| Storage | Local JSON `.dyamm` project (`project.json`, `circuit.json`, `firmware/`, `simulation/`) |
| Assets | `assets/{components,symbols,icons}/` |

## Deferred decisions (PRD §63)
Emulator integration · AVR-GCC-on-Android strategy · solver pick · sync model · native API ·
channel vs FFI split · file formats · timestep strategy · licensing (emulator, solver, toolchain).
