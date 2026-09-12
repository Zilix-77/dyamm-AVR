# UI Architecture

> Source: PRD §§27–30, 34. Code: `lib/app.dart`, `lib/features/schematic/workspace.dart`.
> Status: Phase 0 shell implemented; deviations from the PRD target marked below.

## CAD workstation, not a dashboard (§27)
Canvas dominates. Panels are a `Drawer` in Phase 0 — movable/resizable/dockable (§34)
is Planned.

```text
┌ Top toolbar: project name, Close, Run/Pause/Stop placeholders
├ Left project Drawer: name + Schematic/Firmware placeholders (§30 partial)
├ Center 2D schematic canvas (§31 partial: grid + pan/zoom, no editing yet)
├ Bottom component library strip, visual only (§32 partial)
├ Minimap placeholder box + zoom buttons
└ 3×3 tool pad overlay, visual only (§33 partial)
```

Planned (not Phase 0): Undo/Redo, Save/Open, Settings (§29); search/categories and
drag-to-place (§32); contextual pad actions (§33).

## Rules
Minimal chrome and effects (perf §42); controls drive `*Manager` Notifiers, never engines.

Entry point: the Project Manager screen comes before this workspace — see `PROJECT_MANAGER.md`.
