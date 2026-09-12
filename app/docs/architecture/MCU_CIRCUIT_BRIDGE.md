# MCU ↔ Circuit Bridge

> Source: PRD §17 (critical component), §§14–15. Code: `lib/bridge/simulation_bridge.dart`,
> `native/bridge/`.

ATmega32 is **not** a SPICE part — it couples through the bridge:

```text
AVR Emulator (GPIO/ADC/PWM) ⇄ McuBridge ⇄ Circuit Engine (nets)
```

## Flows
- **Digital out:** `PB0=HIGH → GPIO → bridge → net → R → LED ON`.
- **Digital in:** button → circuit state → net → bridge → GPIO → firmware.
- **Analog in:** pot → solver voltage → bridge → ADC register → firmware.
- **PWM out:** timer peripheral → pin → bridge → circuit (motor/LED/filter).

## Sync problem (§62.3)
Solver and emulator use different timesteps — a robust sync strategy is an open decision
(§63.4, §63.9). Keep the bridge the **only** coupling point; Phase 5 proves it with the
PB0→R→LED circuit (Phase 5).
