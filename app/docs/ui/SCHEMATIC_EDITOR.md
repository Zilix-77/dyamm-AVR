# Schematic Editor

> Source: PRD §§6.1, 31, 33–35. Stitch truth: `ui/screen.png` + `ui/code.html`.
> Code: `lib/features/schematic/` (`workspace.dart`, `canvas/`,
> `widgets/`, `painters/`, `editor_state.dart`, `geometry.dart`, `symbols.dart`).
> Status: Stitch replica + gestures wired to in-memory session; sim engine
> binding is UI-state only (native bridge untouched).

## Canvas (implemented)

Dark dotted grid (`#050505`, white 16% dots, 20px pitch per `cad-grid`;
note: snap/hit math still uses `AppConstants.gridStep` = 24px) inside
`InteractiveViewer` pan/zoom. `SchematicCanvas` renders session components
+ wires via `_SchematicPainter` (light ink for dark bg, white selection
rect, grey pins/tags) and handles gestures per `activeToolProvider`:
place (armed tile) · select · move-drag · delete · rotate · wire pin→pin ·
switch/button toggle. Zoom pill bottom-left, minimap placeholder top-right
(`workspace.dart`).

## Tool pad (implemented, visual + selection state)

3×3 `ToolPad` bound to `SchematicTool`/`defaultTools` via
`activeToolProvider`; Select renders active-white. `toolLabel()` returns
full names, `toolIcon()` the Material icons. Tool effects beyond selection
state are roadmap-gated (`More` is a planned tooltip).

## Sim binding (UI state only)

Top-bar Run/Pause/Stop → `SimController` (`SimState` toggles, nothing
else). `simStatesProvider` overlays LED/diode glow from the last solver
run when present.

## Tests (implemented)

`test/widget/editor_layout_test.dart` (chrome, dock, zoom/minimap, 11
chips, 13 tiles, pad, sim enable logic, tile arming) +
`test/widget_editor_test.dart` (tile→canvas placement, delete tool).
PRD §49.4 remaining editor-interaction tests (multi-select, copy/paste,
rotation gestures) are planned.
