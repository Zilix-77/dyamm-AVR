# ELF / HEX Handling — Status: Planned (Phase 4–5)

> Per `AGENTS.md`: documents only verified implementation. Nothing here is implemented yet.

## Plan

- ELF is the primary internal firmware representation (PRD §20); HEX is export-only.
- Known constraint (verified by reading upstream `simavr/sim/sim_elf.c:801-807`):
  without `HAVE_LIBELF`, `elf_read_firmware()` fails — NDK ships no libelf, so the
  ELF-loading strategy (cross-built libelf vs minimal parser vs HEX stepping stone)
  is TBD in Phase 4.
- `sim_default_mcu` derives the MCU from `atmega32_*`-style filenames.

## To Be Verified

Loader choice, chunk mapping, flashbase handling, symbol support. Documented when tested.
