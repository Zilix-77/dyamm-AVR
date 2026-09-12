# Project Manager & Project System

> Phase 1–2. SimAVR is project-based: the user experience begins here, not in the simulator.

## First-run flow

```text
Launch → Project Manager → New/Open Project → Main Editor → Build/Edit/Simulate
```

## Project Manager (Phase 1)

Conceptually supports:

- **New Project** → project configuration (name, MCU, clock) → opens Main Editor
- **Open Project** → file picker for existing `.dyamm` projects
- **Recent Projects** → last-opened list with quick resume
- **Import Project** → where applicable (e.g. `.zip` AVR sources into a new project)
- **Project information/settings** → rename, MCU target, storage location

## Main Editor (target layout)

Unchanged engineering workspace (see `UI_ARCHITECTURE.md`):

- Top application bar · project/file panel · large 2D schematic canvas · dotted grid
- Component library with search/categories · simulation controls · minimap · zoom controls
- 3×3 contextual tool pad · movable/resizable/collapsible panels

## Project contents (Phase 2, format TBD)

A project eventually contains:

- project configuration
- schematic data
- firmware / source files
- build artifacts (ELF/HEX)
- simulation configuration

Exact `.dyamm` file format: **TBD** — decided during Phase 2 implementation, not before.
No invented schema is documented here.
