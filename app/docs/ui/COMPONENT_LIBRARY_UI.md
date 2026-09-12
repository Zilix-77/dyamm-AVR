# Component Library UI

> Source: PRD §§25, 32, 47. Stitch truth: `ui/screen.png` + `ui/code.html`.
> Code: `component_library.dart`, `schematic/widgets/library_bar.dart`,
> `schematic/painters/component_symbols.dart` (via `schematic/symbols.dart`).
> Status: Stitch drawer implemented; tap-to-arm placement live, filtering planned.

## Bottom drawer (implemented)

Header (`Component Library` + disabled search with `Phase 3` implication;
search collapses under 460px shelf width) · 11 category chips
(`All/MCU/Basic/Passive/Diodes & Transistors/Logic/Sensors/Display/Power/
Actuators/Misc`, selectable UI state only) · horizontal 13-tile carousel.

Tiles are `CustomPainter` previews that call the same `paintSymbol()` as
the canvas, so strip and schematic can never diverge. Tapping a tile arms
canvas-tap placement through the existing `pendingPlacementProvider`
(real in-memory placement, kept); tapping again disarms.

## Entries (Stitch order, all render)

ATmega32 · Resistor · Capacitor · Inductor · LED · Diode · Button ·
Switch · Potentiom. · GND · VCC · Relay · Transformer
(`componentLibrary` + `componentLabel()` cover all 13; relay/transformer
are render-only `SimSupport.none` until the solver models them).

Growth order (Phase 8): digital → analog → sensors → displays → motors →
comms → MCUs — one enum value + label + symbol case, no drawer redesign.
