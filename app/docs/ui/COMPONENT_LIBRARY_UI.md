# Component Library UI

> Source: PRD §§25, 32. Code: `component_library.dart`, `widgets/library_bar.dart`,
> `components/widgets/component_tile.dart`.
> Status: Phase 0 visual strip only; interaction Planned (Phase 3).

## Bottom strip (implemented, Phase 0)

Horizontal scroll of `Chip` tiles in `componentLibrary` order via `componentLabel()`;
compact so canvas keeps the screen. Tiles are not tappable/draggable yet.
Planned: search + categories + symbol previews + drag-to-place.

## MVP entries (§47)

ATmega32 · R · C · LED · Diode · Btn · Pot · VCC · GND (+ Switch, DC source in model).
Growth order (Phase 8): digital → analog → sensors → displays → motors → comms → MCUs —
each addition is one enum value + label + tile, no strip redesign.
