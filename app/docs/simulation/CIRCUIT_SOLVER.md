# Circuit Solver — Status: Planned (Phase 6)

> Per `AGENTS.md`: documents only verified implementation. Nothing here is implemented yet.

## Plan

- SPICE-style (MNA) network simulation; engine **TBD** — RSpice / ngspice candidates,
  benchmarked on Android per PRD §13 before locking in.
- Responsibilities (PRD §12): nets, netlist, node voltages, branch currents,
  analog + digital signals, transient steps, measurement data.

## To Be Verified

Solver choice, API, timestep strategy, convergence behavior, performance on
10/50/100/500+ component circuits. Documented when measured.
