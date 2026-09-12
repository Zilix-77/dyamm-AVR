# Project Manager & Project System

> SimAVR is project-based: the user experience begins here, not in the simulator.
> Phase 0 implemented the Manager screen + in-memory session (see Status below).

## First-run flow (implemented, Phase 0)

```text
Launch → Project Manager → New/Open Project → Main Editor
```

`RootScreen` (`lib/app.dart`) switches on `sessionProvider.active`: null → Manager,
set → Editor. No routes yet.

## Project Manager (implemented, Phase 0)

`lib/features/project/project_manager_screen.dart`:

- **New Project** → name dialog; blank names rejected inline (`Enter a project name`);
  names trimmed; creates in-memory `Project` and opens the editor.
- **Recent Projects** → in-memory list, most-recent-first, tap to reopen.
- Empty state card when there are no projects.
- Session state: `ProjectSession { recents, active }` in `project_manager.dart`
  (`create` / `open` / `close` / `addComponent`).

## Planned (not in Phase 0)

- **Open Project** via file picker for `.dyamm` files (Phase 2).
- **Import Project** (e.g. `.zip` AVR sources).
- **Project information/settings** (rename, MCU target, storage location).
- Persistence of any kind — session is lost on restart.

## Main Editor (Phase 0 shell)

Engineering workspace, see `UI_ARCHITECTURE.md`. Layout only; engines unwired.

## Project contents (Phase 2, format TBD)

A project eventually contains: configuration · schematic data · firmware/sources ·
build artifacts (ELF/HEX) · simulation configuration.

Exact `.dyamm` file format: **TBD** — decided during Phase 2 implementation, not before.
No invented schema is documented here.
