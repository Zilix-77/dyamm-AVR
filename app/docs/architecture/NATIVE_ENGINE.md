# Native Engine (C++/NDK)

> Source: PRD §§9–10, 12–13, 16, 62–63. Code: `native/` + `lib/bridge/native_bridge.dart`.

## Modules
- `native/avr/` — dyamm-AVR emulator + ATmega32 config (Phase 0). Contract: `AvrEngine`
  (`loadElf`, `readGpio`). Emulator hidden behind the interface so it can be swapped (§16).
- `native/circuit/` — SPICE-style solver (Phase 2). Contract: `CircuitSolver.solve(netlist)`.
  Engine **undecided**: RSpice vs ngspice — pick by Android compat, perf, memory, API,
  capabilities, license, integration ease (§13). Do not lock in before benchmarking.
- `native/compiler/` — AVR-GCC + AVR Libc on Android (Phase 1, biggest risk §62.1).
  Contract: `Toolchain.compile` over MethodChannel; sandboxed, restricted binaries/args only (§52).
- `native/bridge/` — see `MCU_CIRCUIT_BRIDGE.md`.

## Rules
C++ stays platform-independent where practical (§56); Flutter talks FFI for the hot loop,
MethodChannel for the toolchain; release engine resources on Stop (§53).
