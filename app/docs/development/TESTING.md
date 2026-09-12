# Testing — Status: Partial (app shell only)

## Verified

- `flutter test` passes: widget smoke test (workspace shell) + unit test
  (component `.dyamm` JSON serialization) in `app/test/`.

## Planned

- Phase 1: widget tests for Project Manager, canvas interactions, panels, tool pad.
- Phase 2: project save/open round-trip + corruption tests.
- Phase 3–4: native round-trip test; known-ELF → GPIO assertion on device.
- Phase 7: perf tests at 10/50/100/500+ components (PRD §50).

## TBD

On-device test harness, CI. Documented when set up.
