# Schematic Editor

> Source: PRD §§6.1, 31, 33–35, Phase 1. Code: `lib/features/schematic/`.
> Status: Phase 0 static shell; editing and sim binding are Planned (Phase 1/3+).

## Canvas (implemented, Phase 0)

Dotted grid (`AppConstants.gridStep`), `InteractiveViewer` pan/zoom
(`minScale`/`maxScale`) via `SchematicCanvas` + `GridPainter`; zoom in/out/reset
buttons (`ZoomControls`); `MinimapPlaceholder` box reserves layout space.
Canvas content is static placeholder text — it does not render project components yet.

## Editing (Planned, Phase 1)

Place · move · rotate · wire/net create + edit · select/multi-select · delete ·
cut/copy/paste/duplicate · labels · power · properties. `SchematicTool` enum +
`defaultTools` order already back the visual 3×3 pad; actions unwired.

## Sim binding (UI state only, engine Planned Phase 3+)

Toolbar Run/Pause/Stop → `SimController` (toggles `SimState`, nothing else).
`SimulationSnapshot` exists but no live data feeds it yet.
Tests (implemented): PM-first, empty state, create→editor→close flow, session unit tests.
PRD §49.4 editor-interaction tests are Planned.
