# Firmware Pipeline

> Source: PRD §§18–22. Code: `lib/features/firmware/`, `native/compiler/`.

## No in-app IDE (§18)
Users write firmware externally; the app imports, builds, loads, runs.

```text
Existing AVR project (.c/.h/.zip, §19) → Import → BuildConfig (§21) → AVR-GCC
→ objects → linker → ELF (primary) → avr-objcopy → HEX (export) → emulator
```

## MVP build config (§21)
`MCU: atmega32 · Freq: 16 MHz · Opt: -Os · Output: ELF` — modeled in `BuildConfig`.
`FirmwareManager` (Riverpod) holds sources + last `BuildOutput`; `ToolchainService`
abstracts import/build for testability.

## Build panel (§22)
Show `BUILD STARTED … Compiling … Linking … Build successful (firmware.elf, flash/RAM %)`
or on failure the compiler error verbatim (`main.c:24:5: error: …`) and stop.
Treat imports as untrusted: sandboxed FS, restricted binaries/args (§52).
