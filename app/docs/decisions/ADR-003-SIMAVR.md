# ADR-003: simavr as the AVR emulator

- Status: Accepted
- Date: 2026-09-12
- Context: Building an AVR core by hand (old `plan.md` Phase 1) duplicates a mature,
  tested emulator. simavr supports ATmega32, loads ELF/HEX, and exposes GPIO/UART/ADC
  peripherals the product needs (PRD §§15–16).
- Decision: Integrate upstream simavr (v1.8 vendored for inspection) as the AVR engine,
  hidden behind the `AvrEngine` interface so it can be swapped later (PRD §16).
- Consequences: Phase 1 vendors a minimal subset (core + mega32, no gdb/dwarf);
  ELF loading needs a libelf strategy (see `../firmware/ELF_HEX_HANDLING.md`) — HEX first in Phase 1.
