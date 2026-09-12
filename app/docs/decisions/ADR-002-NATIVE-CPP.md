# ADR-002: C++ via Android NDK for simulation engines

- Status: Accepted
- Date: 2026-09-12
- Context: Circuit solving and AVR emulation need predictable performance and reuse
  of existing C simulation code on a broad range of Android devices (PRD §§42, 56).
- Decision: Engines in C++ built with Android NDK + CMake; Flutter talks to them via
  FFI for the hot loop (solver/AVR/bridge) and MethodChannel for the toolchain.
- Consequences: `native/` module layout; `externalNativeBuild` wiring in Phase 1;
  keep engine code platform-independent where practical.
