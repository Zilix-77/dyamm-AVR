# Development Roadmap

> Source: PRD §§44, 58–59. Rule: **UI is not the first task** — engines first.

| Phase | Goal | Done when |
|---|---|---|
| 0 Feasibility | AVR emulator on Android NDK, known ELF → GPIO/UART observed | GPIO toggles on-device |
| 1 Toolchain | AVR-GCC on Android → ELF loads into emulator | On-device compile + run |
| 2 Circuit solver | Nets, netlist, solver; `VCC→R→LED→GND` + potentiometer node | Voltages/currents correct |
| 3 Bridge | GPIO→LED (§46), button→GPIO, pot→ADC→LED | MVP circuit responds |
| 4 Schematic UI | Canvas, grid, wiring, edit ops, library, panels, 3×3 pad | §60 UI boxes ticked |
| 5 Firmware UX | Import → build → output panel → load → run | Errors/warnings visible |
| 6 Expansion | Sensors → displays → motors → logic ICs → more MCUs | Per §26/§55 |

Priority order (§58): emulator → toolchain → ELF→MCU → solver → GPIO-LED bridge → ADC
bridge → editor → firmware UX → expansion → advanced sim.
