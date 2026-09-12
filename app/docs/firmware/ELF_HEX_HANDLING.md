# ELF / HEX Handling — Status: In progress (Phase 1, HEX first)

> Per `AGENTS.md`: documents only verified implementation.

## Implemented (Phase 1, HEX)

- JNI loads HEX via `read_ihex_file()` + manual FLASH chunk (`simavr_jni.c`);
  `sim_setup_firmware()` avoided (upstream `exit()` paths).
- Limitation: first HEX region only; multi-region files need the ELF strategy.
- Fixture `native/firmware/atmega32_blink.hex` verified by disassembly.
- `sim_default_mcu` filename convention bypassed: `mmcu` set explicitly.

## TBD (Phase 2)

Full ELF loading (cross-built libelf vs minimal parser); `avr-gcc` rebuild of the
fixture; symbol support.
