# ATmega32 — Status: Planned (Phase 4)

> Component model exists in Dart (`lib/features/mcu/`); emulation is not implemented.

## Planned peripheral support (PRD §15)

CPU · Flash · SRAM · registers · GPIO · digital in/out · ADC · timers · PWM ·
external interrupts · UART. Later: SPI, I²C/TWI, EEPROM, watchdog, analog comparator.

## Verified facts

- Dart side: `McuInterface` + `Atmega32` stub (throws `UnimplementedError`).
- Upstream core definition: `simavr-1.8/simavr/cores/sim_mega32.c` (verified by reading).

## TBD

Emulator wiring, `fCpu` plumbing, peripheral enablement order. Documented when built.
