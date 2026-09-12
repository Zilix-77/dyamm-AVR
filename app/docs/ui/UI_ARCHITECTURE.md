# UI Architecture

> Source: PRD §§27–30, 34. Stitch truth: `ui/screen.png` + `ui/code.html`
> (editor), `ui/DESIGN.md` (Project Manager). Code: `lib/app.dart`,
> `lib/core/theme/editor_theme.dart`, `lib/features/schematic/workspace.dart`.
> Status: Stitch replica implemented on `phase-ui-stitch`; behavior
> placeholders roadmap-gated (see table).

## Two-theme split (as built)

| Surface | Theme | Tokens |
|---|---|---|
| Schematic editor | `editorTheme()` (dark) | canvas `#040404`, panel `#0d0d0d`, card `#161616`, border `#282828`, muted `#7e7e7e`, bright `#f4f4f4` (+ `borderLight/active/pill/sheet/pad` from `code.html`) |
| Project Manager + dialogs | `managerTheme()` (Bauhaus brutalist) | paper `#f5f0e8`, ink `#1a1a1a`, yellow `#ffcc00`, red `#e63b2e`, blue `#0055ff`; 2.5px borders, 5px offset shadows, no radius |

Fonts are system fallbacks everywhere (`monospace` for readouts); no new deps.

## Editor layout (as built, `workspace.dart`)

```text
┌ EditorTopBar (64px): menu · DYAMM mark · <name>.dyamm pill · Run/Pause/Stop · cluster
├ Row: ProjectPanelBody dock (256px, collapsible via menu)
│      ├ Column: SchematicCanvas stack (Minimap TR, ZoomPill BL) + 192px shelf
│      └ Shelf row: ComponentLibraryBar (flex) + ToolPad (216px)
```

* `EditorTopBar` — Run/Pause/Stop wired to `SimController` (same enable
  logic as before); grid/snap/undo/redo/bookmark/settings are disabled
  placeholders with honest tooltips. Under 860px wide, brand text and
  button labels collapse to icons so the bar fits phones.
* `ProjectPanelBody` — shared content for fixed dock (drawer wrapper
  `ProjectPanel` kept for reuse). New → existing `NewProjectDialog`;
  Open → first of `session.recents`; Save wired to `.dyamm` files
  (`FileProjectStorage`); Save As disabled (no rename flow yet);
  PROPERTIES/SIMULATION/LAYERS are `ExpansionTile` placeholders.
* `MinimapPlaceholder` — dotted field + viewport-rect outline; live
  tracking planned. `ZoomPill` — `-` / live `%` / `+` / reset via the
  existing `TransformationController`.
* Canvas gestures (place/select/move/delete/rotate/wire) live in
  `SchematicCanvas` + `editor_state.dart` providers; symbols from
  `symbols.dart` re-inked for dark (`#E8E8E8` ink, grey wires/pins/tags).
* `AndroidManifest.xml`: `sensorLandscape` (landscape-only).

## Rules

Minimal chrome and effects (perf §42); controls drive `*Manager`/
`*Controller` Notifiers, never engines. No fake engine behavior: anything
not backed by state is a visibly disabled placeholder with a phase tooltip.

Entry point: the Project Manager screen comes before this workspace — see `PROJECT_MANAGER.md`.
