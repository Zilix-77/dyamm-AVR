# Firmware System

> Source: PRD §§18–22, 52. Code: `lib/features/firmware/`.

## What it is / isn't
Import + build + load pipeline only — **not** a code editor (§18, out-of-scope §7).

## Import (§19)
`.c`, `.h`, `.zip` now; later Makefiles, project dirs, custom configs. Typical layout
`src/main.c, include/*.h, Makefile` — `importProject(path) → sources`.

## Build (§§20–22)
`BuildConfig` (mcu/fCpu/opt) → `ToolchainService.build` → `BuildOutput(success, log, elfPath)`.
ELF feeds `AvrEngine.loadElf`; HEX is export-only. Phase 5 UX: select ATmega32 → Firmware →
Import → Build → output panel (status, errors, warnings, ELF path) → Load → Run.

## Safety (§52)
Untrusted input: sandbox FS, validate project files, restrict compiler binaries/args,
no extra Android permissions; firmware executes **only** inside the AVR emulator.
