# AVR-GCC Pipeline — Status: Planned (Phase 5)

> Per `AGENTS.md`: documents only verified implementation. Nothing here is implemented yet.

## Plan

- AVR-GCC + AVR Libc + binutils packaged for Android (PRD Phase 5; biggest risk §62.1).
- `C sources → objects → linker → ELF` (primary) → `avr-objcopy → HEX` (export).
- MVP config: `MCU atmega32 · 16 MHz · -Os` (`BuildConfig` in `lib/features/firmware/`).
- Imports treated as untrusted: sandboxed FS, restricted binaries/args (PRD §52).

## To Be Verified

Packaging approach, binaries, build commands, on-device compile times, error formats.
Documented when tested. See also `../architecture/FIRMWARE_PIPELINE.md`.
