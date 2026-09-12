# Schematic Editor

> Source: PRD §§6.1, 31, 33–35, Phase 1. Code: `lib/features/schematic/`.

## Canvas (§31)
Infinite 2D, dotted grid (`AppConstants.gridStep`), snap-to-grid, `InteractiveViewer`
pan/zoom (`minScale`/`maxScale`). Renders `ProjectManager` components + wires via
`GridPainter`; selection in `models/schematic.dart`.

## Editing (§6.1)
Place · move · rotate · wire/net create + edit · select/multi-select · delete ·
cut/copy/paste/duplicate · labels · power · properties. `SchematicTool` enum +
`defaultTools` order back the 3×3 pad (`Select/Move/Wire/Delete/Cut/Copy/Paste/Rotate/More`,
overflow: mirror, duplicate, align, measure, probe, label, grid, snap).

## Sim binding (§35)
Toolbar Run/Pause/Stop → `SimController`; canvas reflects `SimulationSnapshot`
(LED states, net highlights). UI tests (§49.4): place/move/wire/select/rotate/delete/
clipboard/save-load/panels/controls.
