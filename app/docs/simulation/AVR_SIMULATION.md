# AVR Simulation — Status: Planned (Phase 4)

> Per `AGENTS.md`: documents only verified implementation. Nothing here is implemented yet.

## Plan (from recon, not yet built)

- Vendor minimal simavr subset: `sim/sim_*.c`, `sim/avr_*.c`, `cores/sim_mega32.c`
  (+ `sim_megax*`); device header `cores/avr/iom32.h` is vendored upstream.
- Exclude from Android build: `sim_gdb.c` (sockets), `sim_dwarf.c` (libdwarf); VCD optional.
- JNI surface mirrors `run_avr.c`: `avr_make_mcu_by_name` → `avr_init` →
  `avr_load_firmware` → `avr_run` → `avr_terminate`.
- GPIO observation: `AVR_IOCTL_IOPORT_GETSTATE('B')` or IRQ notify
  (cf. upstream `tests/test_atmega48_ioport.c`).

## Verified facts

- Upstream `simavr-1.8/` present in repo, untouched.
- No native code exists under `app/android/` yet.
- `avr-gcc` not on PATH (needed to build test firmware).
- Without `HAVE_LIBELF`, `elf_read_firmware()` returns -1 — ELF strategy TBD (Phase 4).

## To Be Verified

Build commands, JNI signatures, GPIO readings, cycle timing. Documented when measured.
