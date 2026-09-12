# dyamm-AVR Schema design — Project Overview

> Source: [`prd.md`](../../prd.md) §§1–5, 65–66. This file distills; PRD is authoritative.

## What
Lightweight **Android** app for 2D schematic design + simulation of embedded circuits,
initially focused on the **ATmega32**. Engineering tool, not a game or general IDE (PRD §1, §7).

## Defining pipeline (PRD §66)
```text
AVR C Firmware → AVR-GCC → ELF → Virtual ATmega32 → MCU/Circuit Bridge → Simulated Electronics → Observable Behavior
```

## Core workflow (PRD §8)
```text
Create Project → Schematic Canvas → Place ATmega32 + components → Wire → Import AVR C project
→ Compile (local AVR-GCC) → ELF → Load → Run → Firmware ↔ Circuit → Measure/Debug
```

## Users (PRD §5)
Electronics students, embedded developers (GPIO/sensors/LEDs/displays), hobbyists.

## Principles (PRD §65)
Engineering-first · lightweight · offline-first · modular · extensible · real firmware execution.

## MVP proof (PRD §§45–46, 60–61)
ATmega32 PB0 → Resistor → LED → GND, firmware sets `PORTB |= (1 << PB0)`, LED turns ON —
entirely on-device, no PC or cloud.
