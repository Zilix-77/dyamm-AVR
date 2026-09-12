# Component System

> Source: PRD §§23–24, 43-P3, 56. Code: `lib/features/components/`, `lib/features/mcu/`.

## Common abstraction (§23)
```text
Component: ID · Type · Position · Rotation · Pins · Properties · Symbol · SimModel
```
Code: `Component` + `Pin` in `models/component.dart` with `toJson()` for `.dyamm` (§39–§40).
ATmega32 extends it with `Firmware · EmulatorInstance · Bridge` (§24 → `atmega32.dart`).

## Extensibility (P3)
New types join `ComponentType` + `componentLibrary` + symbol/params — no simulator rewrite.
`ComponentTile` renders any entry; the solver resolves models by type string.

## Growth path (§§25–26, Phase 8)
MVP → digital → analog → sensors → displays → motors → comms → more MCUs (all behind
`McuInterface`, §54). Each addition ships model + symbol + solver hook + library entry.
