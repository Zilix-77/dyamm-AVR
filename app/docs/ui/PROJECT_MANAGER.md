# Project Manager & Project System

> DYAMM is project-based: the user experience begins here, not in the simulator.
> Stitch truth: `ui/DESIGN.md` (Bauhaus Neo-Brutalist). Code:
> `lib/features/project/project_manager_screen.dart`,
> `lib/core/theme/editor_theme.dart` (`managerTheme()`, `Brutalist`).

## First-run flow (implemented)

```text
Launch → Project Manager → New/Open Project → Main Editor
```

`RootScreen` (`lib/app.dart`) switches on `sessionProvider.active`: null → Manager,
set → Editor. No routes yet.

## Project Manager (implemented, brutalist restyle on `phase-ui-stitch`)

Paper `#f5f0e8` ground, ink `#1a1a1a` blocks, 2.5px borders with 5px
offset shadows, oversized `DYAMM-AVR` headline, yellow `NEW PROJECT` CTA,
uppercase section bands (`RECENT PROJECTS`, `ON THIS DEVICE`). System
fonts only (Space Grotesk/Inter deferred — zero new deps).

Behavior (unchanged, existing logic):

- **New Project** → name dialog; blank names rejected inline (`Enter a project name`);
  names trimmed; creates in-memory `Project` and opens the editor.
- **Recent Projects** → in-memory list, most-recent-first, tap to reopen.
- **On This Device** → on-disk `.dyamm` list via `FileProjectStorage`, tap to open.
- Empty states for both lists.
- Session state: `ProjectSession { recents, active }` in `project_manager.dart`
  (`create` / `open` / `close` / `addComponent` / moves / wires / save).

## Planned (not implemented)

- **Open Project** via system file picker (import from anywhere).
- **Import Project** (e.g. `.zip` AVR sources).
- **Project information/settings** (rename, MCU target, storage location).
- **Save As / Delete** flows.

## Persistence (implemented)

`FileProjectStorage` (`services/project_storage.dart`): one `<name>.dyamm` JSON
file per project under app-documents `simavr_projects/` (`save` / `open` /
`list`). Drawer Save writes the active project; PM `ON THIS DEVICE` lists and
opens saved files; corrupt/missing opens fail soft (`openSaved` → false +
snackbar). Session recents remain in-memory only.

## Main Editor (Phase 0 shell)

Engineering workspace, see `UI_ARCHITECTURE.md`. Layout only; engines unwired.

## Project contents (Phase 4, format TBD)

A project eventually contains: configuration · schematic data · firmware/sources ·
build artifacts (ELF/HEX) · simulation configuration.

Exact `.dyamm` file format: **TBD** — decided during Phase 4 implementation, not before.
No invented schema is documented here.
