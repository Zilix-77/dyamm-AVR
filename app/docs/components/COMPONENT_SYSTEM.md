# Component System

> Source: PRD §§23–24, 43-P3, 56. Code: `lib/features/components/`, `lib/features/mcu/`.

## Common abstraction (§23, implemented)

```text
Component: ID · Type · Position · Rotation · Pins(+geometry) · Properties · Symbol · SimModel
```

Code: `Component` + `Pin` (with `dx`/`dy` symbol offsets) in `models/component.dart`
with `toJson()`/`fromJson()` for `.dyamm` (§39–§40), `copyWith` for edits.
ATmega32 extends it with `Firmware · EmulatorInstance · Bridge` (§24 → `atmega32.dart`).

## Catalog (implemented)

`componentSpecs`: per-type default properties + default pins + `SimSupport`
(`full` / `open` / `short` / `none`). `makeComponent()` builds placed instances.
14 types: ATmega32, resistor (220 Ω), LED (Vf 2.0), diode (Vf 0.7), capacitor
(DC open), inductor (DC short), button/switch (`closed` flag), potentiometer
(render-only), VCC (5 V), GND, DC source (5 V), relay + transformer (render-only).

## Extensibility (P3)

New types join `ComponentType` + `componentLibrary` + `componentSpecs` + symbol —
no simulator rewrite. Library tiles render from the same `paintSymbol` painter
as the canvas, so previews always match placed components.

## Growth path (§§25–26, Phase 8)

MVP → digital → analog → sensors → displays → motors → comms → more MCUs (all behind
`McuInterface`, §54). Each addition ships model + symbol + solver hook + library entry.
