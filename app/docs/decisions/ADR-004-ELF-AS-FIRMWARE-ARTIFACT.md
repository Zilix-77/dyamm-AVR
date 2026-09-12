# ADR-004: ELF as the firmware artifact

- Status: Accepted
- Date: 2026-09-12
- Context: The pipeline needs one artifact from compiler to emulator that also carries
  MCU/frequency metadata (via the `.mmcu` section) for correct setup.
- Decision: ELF is the primary internal representation; HEX via `avr-objcopy` is
  export-only (PRD §20). `BuildConfig` defaults: `atmega32 · 16 MHz · -Os`.
- Consequences: Android build of the emulator must solve ELF parsing without NDK
  libelf (options: cross-built libelf, minimal parser, HEX stepping stone) — TBD Phase 4.
