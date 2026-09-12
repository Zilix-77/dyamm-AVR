# Simulation Engine

> Source: PRD §§12–13, 35–37, 50–51. Code: `lib/features/simulation/`, `native/circuit/`.

## Flow (§12.2)
```text
Circuit Model → Netlist → Solver → Electrical State → Component State → MCU Bridge
```

## Responsibilities
Nets, netlist gen, node voltages, branch currents, analog + digital signals, transient steps,
component updates, measurement data. Solver is SPICE-style (MNA); engine pick pending (§13).

## Controls (§35)
`STOPPED → RUNNING ⇄ PAUSED → STOPPED`, plus reset, speed, and step where feasible —
`SimController` (Riverpod) + `SimulationService` contract; `SimulationSnapshot`
(state/gpio/adc) feeds probes.

## Measurement & debug (§§36–37)
Probe / V-meter / A-meter / logic monitor / waveform (later); GPIO/ADC/PWM/UART state panel.
Perf: test 10/50/100/500+ components for startup, memory, solve latency, frame rate (§50).
Errors: floating nodes, missing GND, bad params, non-convergence with cause hints (§51).
