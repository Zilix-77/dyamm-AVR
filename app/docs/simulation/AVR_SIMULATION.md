# AVR Simulation — Status: Complete with caveat (Phase 1)

> Per `AGENTS.md`: documents only verified implementation.

## Implemented (Phase 1, HEX path)

- Vendored subset at `android/app/src/main/cpp/third_party/simavr/`: all
  `sim/sim_*.c` + `sim/avr_*.c` (minus `run_avr.c`, which owns `main()`),
  `cores/sim_mega32.c` + `cores/sim_megax.c` (family `mx_init`/`mx_reset`),
  `cores/avr/iom32.h`. Upstream `simavr-1.8/` untouched.
- Correction to the old plan: `sim_gdb.c`, `sim_dwarf.c`, `sim_vcd_file.c` are
  **included** — `sim_avr.c`/`sim_core.c`/`avr_uart.c` call into them, so excluding
  breaks the link. They stay dormant (no gdb port, no VCD traces). `sim_dwarf.c`
  already ships a no-libdwarf fallback.
- Hand-written generator equivalents: `sim_core_decl.h` (single-entry `avr_kind[]`;
  `AVR_KIND_DECL` is set by `sim_avr.c` itself) and `sim_core_config.h`
  (`CONFIG_SIMAVR_VERSION` only).
- JNI (`cpp/simavr_jni.c`, registered in `JNI_OnLoad`): init → `loadHex` →
  `runCycles` → `getPortB` → terminate. `sim_setup_firmware()` is deliberately
  avoided (calls `exit()`); HEX loads via `read_ihex_file()` + a manual FLASH
  `fw_chunk_t`, with a readability pre-check (upstream NULL-deref).
- PORTB observed via `AVR_IOCTL_IOPORT_GETSTATE('B')`, packed
  `(pin << 16) | (ddr << 8) | port` (`PortB.unpack` in Dart).
- No `AVR_CORE` define: upstream sets it only for `cores/`, and `sim_avr.h`
  hides the logger typedef behind `#ifndef AVR_CORE` while `sim_avr.c` needs it.

## Verified facts

- Upstream `simavr-1.8/` present in repo, untouched.
- `avr-gcc` not on PATH — fixture `native/firmware/atmega32_blink.hex` hand-assembled
  (`sbi 0x17,0; sbi 0x18,0; rjmp .`), checksum + disassembly verified with
  Microchip `avr-objdump`; `atmega32_blink.c` records intended source for the
  Phase 2 avr-gcc rebuild.
- `assembleDebug` links `libsimavr_jni.so` (all 32 TUs compile under NDK 28).
- Dart: `MethodChannelAvrEngine` on `simavr/emulator`; `PortB.unpack` unit-tested;
  channel contract mock-tested on host.
- On-device run verified: TEMP self-test (since removed) PASS ×5 — init handle valid,
  load rc=0, 100 cycles, PORTB port/ddr/pin = 1/1/1 (vivo arm64).

## Follow-up (not blocking closure)

- Timers/interrupts: compiled in, dedicated firmware exercise pending.
- Full ELF loading (libelf strategy, Phase 2).
- One SIGSEGV incident (DEBUGGING.md), not reproduced across 5 PASS runs.
