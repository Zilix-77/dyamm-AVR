---
name: source-driven-development
description: "Authoritative verification against official specs, datasheets, and source code instead of relying on memory."
---

# Source-Driven Development Skill

## Purpose

Ensure every hardware peripheral behavior, toolchain flag, register bit mapping, or API call is directly verified against official, authoritative technical sources rather than AI training memory.

## Authoritative Source Hierarchy (AVR Studio Next)

1. **ATmega32 Complete Datasheet** (Microchip DS40002072 / Atmel 2503).
2. **AVR-GCC & AVR Libc Official Documentation** (GNU & Savannah documentation).
3. **`simavr` Source Code Headers** (`sim_avr.h`, `sim_io.h`, `sim_megax.h`).
4. **Qt 6 Framework API Documentation** (Qt Widgets, Qt Core C++ reference).
5. **CMake Official Reference Manual**.

## Rules

- Never guess C++ struct member names, enum values, or register bit shifts. Inspect the actual header or datasheet first.
- Cite the authoritative source (document name, section, or source file path) when writing hardware-critical code.
- If an exact API signature or register mapping cannot be confirmed from source, mark it as `UNCONFIRMED` until verified.

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "I know the ATmega32 register names by heart." | Bit positions (e.g. `UCSRC` vs `UBRRH` register sharing on ATmega32) have subtle quirks that require exact datasheet verification. |
| "The LLM memory is usually accurate." | Memory is statistical; source code is deterministic. Always read the source. |

## Verification

- Code comments or docs cite exact datasheet sections, header lines, or official manual references.
