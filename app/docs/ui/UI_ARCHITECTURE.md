# UI Architecture

> Source: PRD §§27–30, 34. Code: `lib/app.dart`, `lib/features/schematic/workspace.dart`.

## CAD workstation, not a dashboard (§27)
Canvas dominates; panels are movable/resizable/collapsible/dockable (§34).

```text
┌ Top toolbar: app name, Run/Pause/Stop, Undo/Redo, Save/Open, Settings (§29)
├ Left project panel: files, circuit, firmware, sim info (§30)
├ Center 2D schematic canvas (§31)
├ Bottom component library strip (§32)
└ 3×3 tool pad overlay, bottom-right, contextual (§33)
```

## Rules
Minimal chrome and effects (perf §42); controls drive `*Manager` Notifiers, never engines;
panels expose collapse/resize/dock from day one so layout work isn't redone later.
