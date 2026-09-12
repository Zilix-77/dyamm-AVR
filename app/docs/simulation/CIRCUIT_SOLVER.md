# Circuit Solver — Status: Implemented, DC only (no phase tag; see roadmap)

> Per `AGENTS.md`: documents only verified implementation.

## Actual implementation

Pure-Dart Modified Nodal Analysis in `lib/features/simulation/solver/mna_solver.dart`
(`solveDc(Project)` → `CircuitSolution`). No native code, no external engine —
the RSpice/ngspice selection (PRD §13) is deferred to the full analog phase.

- **Nets:** union-find over wire endpoints (`comp.pin` keys); GND-pin nets fixed at 0V.
- **Stamps:** resistors (non-positive R falls back to 0.01 Ω), voltage sources
  (VCC, DC source), closed switches/buttons as 0.01 Ω, inductors as shorts,
  capacitors as opens, LEDs/diodes as fixed-Vf + series-Ron when forward-biased.
- **LED fixpoint:** all-off solve → turn on forward-biased (`Va − Vb > Vf`) →
  re-solve, max 4 passes.
- **Numerics:** Gaussian elimination with partial pivot; `gmin` 1e-12 S leakage
  keeps floating nets solvable (standard SPICE practice); unconnected pins read 0V.
- **Errors:** `No ground reference` when powered nets lack GND; `Unsolvable network`
  on singular matrices. Surfaced via `simErrorProvider` banner in the editor.
- **Outputs:** `nodeVoltages` (by net root), `pinVoltages` (`comp.pin`, probe-friendly),
  `componentOn` (LED/diode), `branchCurrents`.
- **Triggering:** `refreshSimulation(ref)` in `simulation.dart` runs after every
  structural edit and on Run; LED glow reads `simStatesProvider`.

## Explicit limits (not bugs)

- DC steady state only. No AC, no transient, no reactive sweeps.
- No models yet: potentiometer, relay, transformer, ATmega32 (open circuits).
- Multi-region HEX/firmware concepts do not apply here — firmware-independent.
- Performance unmeasured beyond unit-test scale (PRD §50 tests are Planned).

## Tests

`test/unit/mna_solver_test.dart`: divider voltages, open/closed switch, floating
source error, capacitor blocks DC.
