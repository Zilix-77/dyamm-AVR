# Component Library UI

> Source: PRD §§25, 32, Phase 6. Code: `component_library.dart`, `widgets/library_bar.dart`,
> `components/widgets/component_tile.dart`.

## Bottom strip (§32)
Search + categories + horizontal scroll; compact so canvas keeps the screen.
Entries come from `componentLibrary` order via `componentLabel()`; `ComponentTile`
(Chip today) becomes symbol preview + drag-to-place target.

## MVP entries (§47)
ATmega32 · R · C · LED · Diode · Btn · Pot · VCC · GND (+ Switch, DC source in model).
Growth order (Phase 6): digital → analog → sensors → displays → motors → comms → MCUs —
each addition is one enum value + label + tile, no strip redesign.
