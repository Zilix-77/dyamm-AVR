# PRD Index

> Full PRD lives at [`../../prd.md`](../../prd.md) (67 sections, v1.0 Draft) and is the
> authoritative spec. This file is a distilled index so docs stay small — read the PRD
> for exact requirements.

## Scope
- **In (§6):** 2D canvas editing · DC/transient/digital/analog sim · ATmega32 (CPU, Flash,
  SRAM, GPIO, ADC, Timers/PWM, Ext-IRQ, UART) · firmware import (`.c`/`.h`/`.zip`) + local
  compile → ELF/HEX · project save/load.
- **Out (§7):** general C++ IDE, full code editor, PCB layout, 3D, cloud build/sim, desktop EDA.

## Key models
- Component abstraction (§23), ATmega32 node (§24), project format (§39–§40), build config (§21),
  build output (§22), measurement (§36), debug view (§37), errors (§51).

## Non-functional (§§41–43, 56)
Offline-first · fast startup / low memory / efficient render · UI separated from simulation ·
modular engines · extensible components/MCUs.

## Acceptance
MVP checklist (§60), success flow (§61), first milestone: run an ELF on Android and observe
GPIO (§59). Risks: AVR-GCC on Android, solver choice, MCU/circuit sync (§62); open decisions (§63).
