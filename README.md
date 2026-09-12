# dyamm-AVR

Project-based engineering environment for designing and simulating ATmega32-based
electronic circuits on Android: schematic editing, AVR firmware pipeline, and
MCU <-> circuit simulation.

## User flow

```text
Launch App -> Project Manager -> New/Open Project -> Main Editor -> Build/Edit/Simulate
```

The simulator is the engine underneath the application; the experience starts with projects.

## Docs

- Product: [prd.md](prd.md) (requirements; build order superseded - see note at top of file)
- Roadmap (authoritative order): [app/docs/04_DEVELOPMENT_ROADMAP.md](app/docs/04_DEVELOPMENT_ROADMAP.md)
- Overview: [app/docs/00_PROJECT_OVERVIEW.md](app/docs/00_PROJECT_OVERVIEW.md)
- Doc/agent rules: [AGENTS.md](AGENTS.md)

Development order: Phase 0 App Foundation -> ATmega32 emulator (Phase 1) ->
AVR-GCC (Phase 2) -> Main Editor -> Project System -> bridges -> circuit sim ->
release.
