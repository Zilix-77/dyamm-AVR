# Architecture (summary)

> Source: PRD §§9, 11, 43–44, 54, 64. Details: [`architecture/`](architecture/).

## Layers
```text
Flutter UI (Canvas │ Panels │ Library │ Controls)
        ↓
Application Layer (Project │ Circuit │ Netlist │ Firmware)
        ↓
Native Engine (Circuit Solver │ AVR │ Compiler │ Bridge)
        ↓
Circuit Sim (SPICE engine) + AVR Sim (dyamm-AVR emulator)
```

## Five systems (§11)
UI · Project · Circuit engine · AVR engine · Firmware toolchain — communicating via the
central application layer. UI never touches native directly; only via `lib/bridge/`.

## Principles (§43)
1. UI separate from simulation. 2. Engines modular. 3. Components extensible.
4. MCUs behind `McuInterface` (32 → 16 → 328P, §54). 5. Offline-first.

## Code map
`lib/features/{schematic,components,mcu,simulation,firmware,project}/` ·
`lib/bridge/{native_bridge,simulation_bridge}.dart` · `native/{avr,compiler,circuit,bridge}/`.
