# Component Specification (MVP)

> Source: PRD §§23–25, 47–48. Code: `component_library.dart`, `models/component.dart`.

| Type | Pins | Properties | Sim model |
|---|---|---|---|
| ATmega32 | 40 (PA/ PB/PC/PD, VCC, GND, AVCC, AREF, XTAL, RESET) | fCpu, elfPath | Emulator + bridge (§24) |
| Resistor | A, B | resistance Ω | MNA conductance |
| LED | A, K | Vf, If_max | Diode + luminous state |
| Push Button / Switch | 2 | momentary/latching | Digital in → net |
| Potentiometer | H, W, L | total Ω, wiper 0–1 | Divider → analog node |
| Capacitor | A, B | capacitance F | Transient susceptance |
| Diode | A, K | Vf | Exponential junction |
| VCC / GND / DC source | 1 / 1 / +,− | voltage V | Ideal rail / source |

## Firmware proof tests (§48)
1. `DDRB \|= (1<<PB0); PORTB \|= (1<<PB0);` → LED ON.
2. `PORTB ^= (1<<PB0); _delay_ms(500);` loop → LED blinks.
Symbols live in `assets/symbols/`; metadata in `assets/components/`.
