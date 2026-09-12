# Digital/Analog Bridge — Status: Planned (Phases 6/8)

> Per `AGENTS.md`: documents only verified implementation. Nothing here is implemented yet.

## Plan

- The **only** coupling point between AVR emulator and circuit engine (PRD §17).
- Digital (Phase 6): GPIO out (`PB0=HIGH → net → R → LED ON`), button in, direction handling.
- Analog (Phase 8): potentiometer → solver voltage → ADC; timer PWM → circuit.
- Solver/emulator timestep sync strategy: TBD (PRD §62.3).

## To Be Verified

Sync model, ADC/PWM mappings, latency. Documented when measured.
See also `../architecture/MCU_CIRCUIT_BRIDGE.md` (planned architecture).
