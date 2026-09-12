# UI Architecture

> Source: PRD §§27–30, 34. Stitch truth: `ui/screen.png` + `ui/code.html`
> (editor), `ui/DESIGN.md` (Project Manager). Code: `lib/app.dart`,
> `lib/core/theme/editor_theme.dart`, `lib/features/schematic/workspace.dart`.
> Status: Stitch replica implemented on `phase-ui-stitch`; behavior
> placeholders roadmap-gated (see table).

## Theme (as built)

Unified dark CAD on every surface (`editorTheme()`): canvas `#040404`,
panel `#0d0d0d`, card `#161616`, border `#282828`, muted `#7e7e7e`, bright
`#f4f4f4` (+ `borderLight/active/pill/sheet/pad` from `code.html`). The
Bauhaus-brutalist `DESIGN.md` skin was removed (`Brutalist`/`managerTheme()`
deleted); the Project Manager shares editor tokens in a portrait
file-manager layout. Fonts are system fallbacks everywhere (`monospace`
for readouts); no new deps.

## Editor layout (as built, `workspace.dart`)

```text
┌ EditorTopBar (64px): menu · DYAMM mark · <name>.dyamm pill · Run/Pause/Stop · cluster
├ Row: ProjectPanelBody dock (draggable 180–360px, collapsible via menu)
│      ├ Column: SchematicCanvas stack (live Minimap TR, ZoomPill BL) + shelf (draggable 120–260px)
│      └ Shelf row: ComponentLibraryBar (flex) + ToolPad (160–216px responsive)
└ _DragDivider handles (12px touch target, hover-brighten, keyed for tests)
```

* `EditorTopBar` — Run/Pause/Stop wired to `SimController` (+ solver
  refresh on Run); grid/snap toggles, undo/redo (history-backed), and Save
  (`.dyamm` + snackbar) are live; Settings remains the only placeholder.
  Width tiers: full ≥860px, icon-only compact below, placeholder cluster
  hidden under 600px (rotation frames) so the bar never overflows.
* `ProjectPanelBody` — shared content for fixed dock (drawer wrapper
  `ProjectPanel` kept for reuse). New → existing `NewProjectDialog`;
  Open → first of `session.recents`; Save wired to `.dyamm` files
  (`FileProjectStorage`); Save As disabled (no rename flow yet);
  PROPERTIES/SIMULATION/LAYERS are `ExpansionTile` placeholders.
  Footer/rename rows use `Flexible` + ellipsis so the 180px min width
  never overflows.
* Live `Minimap` — component dots, viewport rect, tap-to-navigate via
  `geometry.dart` viewport math + `canvasSizeProvider`. `ZoomPill` — `-` /
  live `%` / `+` / reset via the existing `TransformationController`.
* Canvas gestures (place/select/move/delete/rotate/wire) live in
  `SchematicCanvas` + `editor_state.dart` providers; symbols from
  `symbols.dart` re-inked for dark (`#E8E8E8` ink, grey wires/pins/tags).
* Viewport preservation: resizing changes layout constraints only; the
  zoom matrix is never touched (covered by `editor_resize_test.dart`).

## Orientation (as built)

Manifest `fullSensor` (no OS lock); `RootScreen` drives
`SystemChrome.setPreferredOrientations` on session transitions only —
PM `[portraitUp]`, editor `[landscapeLeft, landscapeRight]` (hard lock).
Sizes are session-only state (reset when the editor closes).

## Rules

Minimal chrome and effects (perf §42); controls drive `*Manager`/
`*Controller` Notifiers, never engines. No fake engine behavior: anything
not backed by state is a visibly disabled placeholder with a phase tooltip.

Entry point: the Project Manager screen comes before this workspace — see `PROJECT_MANAGER.md`.
