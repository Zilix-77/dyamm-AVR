# Component Specification (MVP)

> Source: PRD §§23–25, 47–48. Code: `component_library.dart`, `models/component.dart`.

| Type | Pins | Properties | DC model (implemented) |
|---|---|---|---|
| ATmega32 | (none yet) | — | Open circuit (bridge later) |
| Resistor | A, B | resistance Ω (220) | MNA conductance |
| LED | A, K | Vf (2.0), Ron (10) | Fixed-Vf + Ron when forward-biased; glow in UI |
| Push Button / Switch | A, B | closed 0/1 | 0.01 Ω when closed, open otherwise; tap toggles |
| Potentiometer | H, W, L | resistance, wiper | Render-only (divider planned) |
| Capacitor | A, B | capacitance F | DC open |
| Inductor | A, B | inductance H | DC short (0.01 Ω) |
| Diode | A, K | Vf (0.7), Ron | Fixed-Vf, no glow |
| Relay / Transformer | — | — | Render-only |
| VCC (1 pin) / GND (1 pin) / DC source (+,−) | voltage V (5.0) | Ideal source / 0 V ref |

## Firmware proof tests (§48)
1. `DDRB \|= (1<<PB0); PORTB \|= (1<<PB0);` → LED ON.
2. `PORTB ^= (1<<PB0); _delay_ms(500);` loop → LED blinks.
Symbols live in `assets/symbols/`; metadata in `assets/components/`.
