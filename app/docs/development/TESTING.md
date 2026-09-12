# Testing — Status: Partial (app + native compile)

## Verified

- `flutter test` passes (8): widget smoke tests + session unit tests +
  component JSON test + `PortB.unpack` test.
- Fixture `atmega32_blink.hex` verified by `avr-objdump` disassembly
  (`sbi 0x17,0; sbi 0x18,0; rjmp .`).
- `assembleDebug` acts as the native compile gate (32 TUs + link).

## Planned

- Phase 3: widget tests for canvas interactions, panels, tool pad.
- Phase 4: project save/open round-trip + corruption tests.
- Phase 1: native round-trip test; known-HEX → GPIO assertion on device.
- Phase 9: perf tests at 10/50/100/500+ components (PRD §50).

## TBD

On-device test harness, CI. Documented when set up.
