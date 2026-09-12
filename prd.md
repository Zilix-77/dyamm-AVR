# Product Requirements Document (PRD)

> **Development-order note:** §§44, 58–59, 62.1, 67 describe an engines-first build order
> (native/AVR proof before the application shell). This is superseded: the authoritative
> development order is `app/docs/04_DEVELOPMENT_ROADMAP.md` (Phase 0 App Foundation →
> ATmega32 emulator at Phase 1 → Main Editor → …). Product requirements
> below still apply; only the build order changed.

# dyamm-AVR Schema design — Android-Based 2D Circuit & Embedded System Simulator

**Version:** 1.0  
**Status:** Draft  
**Platform:** Android  
**Project Type:** Academic / Engineering Software Project  
**Domain:** Embedded Systems, Electronics, Circuit Simulation, Mobile Application Development

---

# 1. Product Overview

## 1.1 Product Name

**dyamm-AVR Schema design**


## 1.2 Product Description

dyamm-AVR Schema design is a lightweight Android application for designing and simulating electronic circuits in a 2D schematic environment.

The application is initially focused on the **ATmega32 microcontroller** and is designed to allow users to combine:

- Electronic circuit design
- Circuit simulation
- AVR firmware compilation
- ATmega32 firmware execution
- Microcontroller peripheral simulation
- Firmware-to-circuit interaction

The user can create a circuit visually, place an ATmega32, connect electronic components, import an existing AVR C project, compile the firmware locally, load the resulting firmware into a virtual ATmega32, and run the complete circuit simulation.

The application is intended to function as an engineering tool rather than a game or general-purpose programming IDE.

---

# 2. Vision

The vision of dyamm-AVR Schema design is to provide a practical embedded-systems simulation environment directly on Android.

The application should allow users to perform a simplified embedded development workflow without requiring a desktop computer:

```text
Circuit Design
      ↓
Firmware Import
      ↓
AVR Compilation
      ↓
ATmega32 Simulation
      ↓
Circuit Simulation
      ↓
Firmware ↔ Circuit Interaction
      ↓
Measurement and Debugging
```

The long-term goal is to create a scalable simulation platform capable of supporting multiple microcontrollers and a large library of electronic components.

---

# 3. Problem Statement

Students and embedded-system developers commonly depend on desktop software for circuit design, firmware compilation, and microcontroller simulation.

Existing Android circuit applications generally provide only basic electrical simulation and may not provide a complete embedded-system workflow involving:

- Real AVR firmware execution
- ATmega32 simulation
- Local AVR-GCC compilation
- Microcontroller peripheral simulation
- Firmware-to-circuit interaction
- Engineering-oriented schematic design

As a result, users may need multiple desktop tools to design a circuit, compile firmware, simulate the microcontroller, and observe the circuit behavior.

dyamm-AVR Schema design aims to combine these capabilities into a lightweight Android-based environment.

---

# 4. Objectives

## 4.1 Primary Objectives

1. Develop a 2D electronic circuit simulator for Android.
2. Support ATmega32 as the initial microcontroller.
3. Execute actual AVR firmware in a virtual ATmega32.
4. Compile AVR C firmware locally on Android.
5. Connect the simulated ATmega32 to the simulated circuit.
6. Support digital and analog interactions between firmware and circuit components.
7. Provide an offline-first simulation workflow.
8. Provide a lightweight and responsive engineering interface.
9. Design the software architecture so additional MCUs and components can be added later.

## 4.2 Secondary Objectives

1. Provide easy schematic editing.
2. Provide component configuration and properties.
3. Provide simulation controls.
4. Provide voltage and current measurements.
5. Provide basic debugging and observation capabilities.
6. Provide project saving and loading.
7. Maintain low resource consumption.
8. Provide a clean and professional engineering-oriented UI.

---

# 5. Target Users

## 5.1 Electronics Students

Students studying:

- Embedded systems
- Microcontrollers
- AVR programming
- Digital electronics
- Analog electronics
- Embedded C

## 5.2 Embedded Developers

Developers who need to quickly test:

- GPIO behavior
- Sensors
- LEDs
- Buttons
- Displays
- Simple embedded circuits
- AVR firmware

## 5.3 Electronics Hobbyists

Users experimenting with:

- ATmega32
- LEDs
- Buttons
- Sensors
- Displays
- Motors
- Basic electronic circuits

---

# 6. Product Scope

## 6.1 In Scope

### Circuit Design

- 2D schematic canvas
- Infinite workspace
- Grid
- Snap-to-grid
- Component placement
- Component movement
- Component rotation
- Wire creation
- Wire editing
- Net creation
- Component selection
- Multi-selection
- Component deletion
- Cut
- Copy
- Paste
- Duplicate
- Labels
- Power connections
- Component properties

### Circuit Simulation

- DC simulation
- Basic transient simulation
- Digital signal simulation
- Analog signal simulation
- Voltage measurement
- Current measurement
- Component state updates
- Basic electrical models

### Microcontroller Simulation

Initial MCU:

- ATmega32

Initial supported peripherals:

- CPU
- Registers
- Flash
- SRAM
- GPIO
- ADC
- Timers/Counters
- PWM
- External Interrupts
- UART

Future peripherals:

- SPI
- I²C/TWI
- EEPROM
- Watchdog
- Analog Comparator
- Additional AVR peripherals

### Firmware

- C source files
- Header files
- AVR project import
- ZIP project import
- Local compilation
- ELF generation
- HEX generation
- Firmware loading
- Firmware execution

### Project Management

- Create project
- Open project
- Save project
- Save As
- Project assets
- Circuit data
- Firmware files
- Simulation configuration

---

# 7. Out of Scope

The initial version will not attempt to become:

- A general-purpose C/C++ IDE
- A full-featured code editor
- A PCB layout application
- A 3D circuit simulator
- A cloud compiler
- A cloud simulation platform
- A professional desktop EDA replacement
- A game-like electronics simulator

The application should focus on engineering functionality and simulation accuracy rather than unnecessary visual effects.

---

# 8. Core User Workflow

The primary workflow is:

```text
Create Project
      ↓
Open Schematic Canvas
      ↓
Place Components
      ↓
Place ATmega32
      ↓
Wire Circuit
      ↓
Configure Components
      ↓
Select ATmega32
      ↓
Import AVR C Project
      ↓
Configure Build
      ↓
Compile Using AVR-GCC
      ↓
Generate ELF
      ↓
Load Firmware
      ↓
Start Simulation
      ↓
ATmega32 Executes Firmware
      ↓
MCU ↔ Circuit Bridge
      ↓
Circuit Responds
      ↓
Observe / Measure / Debug
```

---

# 9. Core System Architecture

```text
┌─────────────────────────────────────────────┐
│                  dyamm-AVR Schema design App                 │
├─────────────────────────────────────────────┤
│                                             │
│                Flutter UI                   │
│                                             │
│   Canvas │ Panels │ Library │ Controls      │
│                                             │
├─────────────────────────────────────────────┤
│             Application Layer               │
│                                             │
│ Project │ Circuit │ Netlist │ Firmware      │
│                                             │
├─────────────────────────────────────────────┤
│              Native Engine                  │
│                                             │
│ Circuit Solver │ AVR │ Compiler │ Bridge    │
│                                             │
├──────────────────────┬──────────────────────┤
│ Circuit Simulation   │ AVR Simulation       │
│                      │                      │
│ SPICE Engine         │ AVR Emulator         │
│                      │                      │
└──────────────────────┴──────────────────────┘
```

---

# 10. Technology Stack

| Layer | Technology |
|---|---|
| Application UI | Flutter |
| UI Language | Dart |
| Native Simulation Layer | C++ |
| Build System | CMake |
| Android Native Integration | Android NDK |
| AVR Emulator | dyamm-AVR Schema design |
| AVR Compiler | AVR-GCC |
| AVR Standard Library | AVR Libc |
| Circuit Solver | RSpice / ngspice candidate |
| Firmware Format | ELF |
| Firmware Export | HEX |
| Project Storage | JSON / custom project format |

The circuit simulation engine should not be permanently locked until suitable candidates have been benchmarked on Android.

---

# 11. High-Level Architecture

The application should be divided into five major systems:

```text
1. UI System
2. Project System
3. Circuit Simulation Engine
4. AVR Simulation Engine
5. Firmware Toolchain
```

These systems communicate through a central application layer.

```text
                    ┌──────────────┐
                    │  Flutter UI  │
                    └──────┬───────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │ Application API │
                  └───────┬─────────┘
                          │
          ┌───────────────┼────────────────┐
          │               │                │
          ▼               ▼                ▼
   Circuit Engine    AVR Engine      Firmware System
          │               │                │
          │               │                │
          └───────┬───────┘                │
                  │                        │
                  ▼                        │
          MCU ↔ Circuit Bridge             │
                  │                        │
                  └────────────────────────┘
```

---

# 12. Circuit Simulation Engine

The circuit simulation engine is responsible for calculating the electrical behavior of the circuit.

## 12.1 Responsibilities

- Represent circuit components.
- Build electrical nets.
- Generate a simulation netlist.
- Calculate node voltages.
- Calculate branch currents.
- Update component states.
- Handle analog signals.
- Handle digital signals.
- Perform transient simulation.
- Provide measurement data.

## 12.2 Basic Simulation Flow

```text
Circuit Model
     ↓
Netlist Generation
     ↓
Circuit Solver
     ↓
Electrical State
     ↓
Component State
     ↓
MCU Bridge
```

---

# 13. Circuit Solver

A SPICE-style simulation engine is preferred for analog circuit simulation.

Potential candidates include:

- RSpice
- ngspice
- Other compatible SPICE/MNA implementations

The final engine should be selected based on:

- Android compatibility
- Performance
- Memory usage
- API accessibility
- Simulation capabilities
- Licensing
- Ease of native integration
- Stability

---

# 14. Microcontroller Simulation

The ATmega32 should be represented as a specialized simulation component.

It should not be treated as an ordinary SPICE component.

The architecture should be:

```text
              ┌─────────────────┐
              │    ATmega32     │
              └────────┬────────┘
                       │
                  AVR Emulator
                       │
          ┌────────────┼────────────┐
          │            │            │
         GPIO         ADC          PWM
          │            │            │
          └────────────┼────────────┘
                       │
              MCU ↔ Circuit Bridge
                       │
                       ▼
                Circuit Engine
```

---

# 15. ATmega32 Support

## 15.1 Initial MCU

The first supported microcontroller is:

**ATmega32**

## 15.2 Required Features

The initial implementation should support:

- CPU execution
- Flash memory
- SRAM
- Registers
- GPIO
- Digital input
- Digital output
- ADC
- Timers
- PWM
- External interrupts
- UART

## 15.3 Future Features

- SPI
- I²C/TWI
- EEPROM
- Watchdog
- Analog comparator
- Additional peripherals

---

# 16. AVR Emulator

The application should integrate an AVR emulator capable of executing actual ATmega32 firmware.

The emulator is responsible for:

- Instruction execution
- CPU state
- Registers
- Program memory
- SRAM
- GPIO
- Timers
- ADC
- UART
- Interrupts
- Other supported MCU peripherals

The emulator should be isolated behind an internal interface so that another AVR emulator can potentially be introduced later.

---

# 17. MCU ↔ Circuit Bridge

The MCU ↔ Circuit Bridge connects the virtual microcontroller with the circuit simulation engine.

This is a critical architectural component.

## 17.1 Digital Output

Example:

```text
Firmware
   ↓
PB0 = HIGH
   ↓
ATmega32 GPIO
   ↓
MCU ↔ Circuit Bridge
   ↓
Circuit Net
   ↓
Resistor
   ↓
LED
   ↓
LED ON
```

## 17.2 Digital Input

```text
Push Button
     ↓
Circuit State
     ↓
Circuit Net
     ↓
MCU ↔ Circuit Bridge
     ↓
ATmega32 GPIO
     ↓
Firmware
```

## 17.3 Analog Input

```text
Potentiometer
      ↓
Analog Voltage
      ↓
Circuit Solver
      ↓
MCU ↔ Circuit Bridge
      ↓
ATmega32 ADC
      ↓
Firmware
```

## 17.4 PWM Output

```text
Firmware
     ↓
PWM Peripheral
     ↓
ATmega32 Pin
     ↓
MCU ↔ Circuit Bridge
     ↓
Circuit
     ↓
Motor / LED / Filter
```

---

# 18. Firmware System

The application is not intended to contain a complete firmware development environment.

Users should primarily write firmware externally and import their existing AVR project.

The application then handles compilation and simulation.

```text
Existing AVR Project
       ↓
Import
       ↓
Build Configuration
       ↓
AVR-GCC
       ↓
ELF
       ↓
AVR Emulator
       ↓
ATmega32
```

---

# 19. Firmware Import

Initial supported formats:

- `.c`
- `.h`
- `.zip`

Future support may include:

- Makefile-based projects
- AVR-GCC project directories
- Custom project configurations

A typical imported project may look like:

```text
project/
├── src/
│   ├── main.c
│   ├── uart.c
│   └── gpio.c
│
├── include/
│   ├── uart.h
│   └── gpio.h
│
├── Makefile
└── ...
```

---

# 20. Firmware Compilation Pipeline

The intended compilation pipeline is:

```text
C Source
   ↓
Preprocessor
   ↓
AVR-GCC Compiler
   ↓
Object Files
   ↓
Linker
   ↓
ELF
   ↓
AVR Emulator
```

Optional firmware export:

```text
ELF
 ↓
avr-objcopy
 ↓
HEX
```

ELF should preferably be the primary internal firmware representation.

---

# 21. Build Configuration

The application should provide controlled build configuration.

Potential configuration parameters:

- MCU
- CPU frequency
- Source files
- Include directories
- Compiler flags
- Linker flags
- Optimization level
- AVR architecture
- Output format

For the initial MVP, configuration should be kept simple.

Example:

```text
MCU: ATmega32
Frequency: 16 MHz
Compiler: AVR-GCC
Optimization: -Os
Output: ELF
```

---

# 22. Build Output

The application should provide a build output panel.

Example:

```text
BUILD STARTED

Compiling main.c...
Compiling uart.c...
Linking...

Build successful.

Output:
firmware.elf

Flash usage: 18%
RAM usage: 12%
```

For compilation failures:

```text
BUILD FAILED

main.c:24:5:
error: 'PORTB' undeclared

Build terminated.
```

---

# 23. Component System

Every component should use a common abstraction.

```text
Component
├── ID
├── Type
├── Position
├── Rotation
├── Pins
├── Properties
├── Symbol
└── Simulation Model
```

Example:

```text
Resistor
├── ID
├── Type
├── Position
├── Rotation
├── Pins
│   ├── A
│   └── B
├── Properties
│   └── Resistance
├── Symbol
└── Simulation Model
```

---

# 24. ATmega32 Component

The ATmega32 requires additional simulation information.

```text
ATmega32
├── ID
├── Position
├── Rotation
├── Pins
├── Properties
├── Symbol
├── Simulation Model
├── Firmware
├── AVR Emulator Instance
└── MCU ↔ Circuit Bridge
```

---

# 25. Initial Component Library

## Passive Components

- Resistor
- Capacitor
- Inductor
- Potentiometer

## Semiconductor Components

- Diode
- LED
- Transistor

## Input Components

- Push Button
- Switch

## Power Components

- VCC
- GND
- DC Voltage Source

## Microcontroller

- ATmega32

---

# 26. Future Component Library

## Sensors

- LDR
- Temperature Sensor
- Ultrasonic Sensor
- IR Sensor

## Displays

- 7-Segment Display
- Character LCD
- OLED
- LED Matrix

## Motors

- DC Motor
- Servo Motor
- Stepper Motor

## Digital ICs

- Logic Gates
- Flip-Flops
- Counters
- Multiplexers
- Shift Registers

## Communication

- UART devices
- SPI devices
- I²C devices

---

# 27. User Interface Requirements

The application should use a professional engineering interface.

The UI should resemble a lightweight CAD/EDA workstation rather than a conventional mobile dashboard.

The primary workspace should be the schematic canvas.

---

# 28. Main UI Layout

```text
┌──────────────────────────────────────────────────────────┐
│ dyamm-AVR Schema design     Run  Pause  Stop   Undo  Redo  Save  Settings│
├──────────────┬───────────────────────────────────────────┤
│              │                                           │
│   PROJECT    │                                           │
│              │                                           │
│   Files      │                                           │
│   Circuit    │             2D SCHEMATIC                  │
│   Firmware   │                CANVAS                     │
│   Components │                                           │
│              │                              ┌──────────┐ │
│              │                              │ Minimap  │ │
│              │                              └──────────┘ │
│              │                                           │
├──────────────┴───────────────────────────────────────────┤
│ Component Library                        ┌───┬───┬───┐   │
│ ATmega32 | R | C | LED | Diode | ...   │   │   │   │   │
│                                         ├───┼───┼───┤   │
│                                         │   │   │   │   │
│                                         └───┴───┴───┘   │
└──────────────────────────────────────────────────────────┘
```

---

# 29. Top Toolbar

The top toolbar should contain only important controls.

## Required Controls

- Application name/logo
- Run
- Pause
- Stop
- Undo
- Redo
- Save
- Open
- Settings

The toolbar should remain minimal.

---

# 30. Project Panel

The project panel is located on the left side.

It may contain:

- Project name
- Circuit files
- Firmware
- Components
- Simulation information
- Project structure

The panel should be:

- Collapsible
- Resizable
- Movable

---

# 31. Schematic Canvas

The schematic canvas is the primary workspace.

## Requirements

- Large workspace
- 2D only
- Dotted grid
- Pan
- Zoom
- Snap-to-grid
- Component placement
- Component movement
- Component rotation
- Wire routing
- Component selection
- Multi-selection
- Labels
- Net visualization

The canvas should occupy most of the available screen.

---

# 32. Component Library

The component library is positioned at the bottom of the application.

It should support:

- Search
- Categories
- Horizontal scrolling
- Component previews
- Component selection
- Drag-and-drop placement

Example:

```text
┌─────────────────────────────────────────────────────┐
│ Search components...                                │
├─────────────────────────────────────────────────────┤
│ ATmega32 │ Resistor │ Capacitor │ LED │ Diode │ ...│
└─────────────────────────────────────────────────────┘
```

The component library should not consume unnecessary screen space.

---

# 33. 3×3 Tool Pad

A contextual 3×3 tool pad should be positioned near the bottom-right of the workspace.

Default tools:

```text
┌────────┬────────┬────────┐
│ Select │ Move   │ Wire   │
├────────┼────────┼────────┤
│ Delete │ Cut    │ Copy   │
├────────┼────────┼────────┤
│ Paste  │ Rotate │ More   │
└────────┴────────┴────────┘
```

The `More` option can expose additional tools:

```text
Mirror
Duplicate
Align
Measure
Probe
Label
Grid
Snap
```

The tool pad should be contextual.

For example, selecting a component may change the available actions.

---

# 34. Panels

Panels throughout the application should support:

- Move
- Resize
- Collapse
- Expand
- Dock
- Undock

The goal is to allow users to customize their workspace.

---

# 35. Simulation Controls

Simulation states:

```text
STOPPED
   ↓
RUNNING
   ↓
PAUSED
   ↓
RUNNING
   ↓
STOPPED
```

Controls:

- Run
- Pause
- Stop
- Reset
- Simulation speed
- Step simulation where technically feasible

---

# 36. Measurement System

The application should eventually support:

- Voltage measurement
- Current measurement
- Digital state inspection
- ADC value inspection
- PWM observation
- GPIO state observation

Possible measurement tools:

- Probe
- Voltage meter
- Current meter
- Logic monitor
- Waveform viewer

---

# 37. Debugging and Observation

The simulator should provide basic visibility into the simulation.

Potential information:

```text
ATmega32
────────────────
CPU Frequency: 16 MHz

GPIO
PB0: HIGH
PB1: LOW
PB2: HIGH

ADC
ADC0: 512

UART
TX: Active
RX: Idle
```

Advanced debugging can be introduced after the MVP.

---

# 38. Project Management

Users should be able to:

- Create project
- Open project
- Save project
- Save As
- Rename project
- Import firmware
- Replace firmware
- Manage project components

---

# 39. Project Format

A native project format may be introduced.

Possible extension:

```text
.dyamm-AVR Schema design
```

Example structure:

```text
project/
├── project.json
├── circuit.json
├── firmware/
│   ├── source/
│   └── build/
├── assets/
└── simulation/
```

The exact project format should be finalized during implementation.

---

# 40. Data Model

A circuit project may contain:

```text
Project
├── Metadata
├── Components
├── Wires
├── Nets
├── Simulation Settings
├── Firmware
└── Assets
```

A component may contain:

```text
Component
├── ID
├── Type
├── Position
├── Rotation
├── Properties
└── Pins
```

---

# 41. Offline-First Requirements

Core functionality should not require an internet connection.

Offline functionality should include:

- Circuit design
- Circuit simulation
- Firmware compilation
- Firmware execution
- Project saving
- Project loading
- Component library
- Basic measurement
- Basic debugging

No cloud service should be required for the normal simulation workflow.

---

# 42. Performance Requirements

The application should prioritize:

- Fast startup
- Low memory usage
- Efficient rendering
- Low simulation latency
- Efficient native computation
- Minimal visual effects
- Efficient project loading
- Efficient circuit solving

The simulator should aim to operate on a broad range of Android devices.

---

# 43. Architecture Principles

## Principle 1 — UI Must Be Separate From Simulation

The UI must not directly contain the core simulation logic.

```text
Flutter UI
    ↓
Application API
    ↓
Native Engine
```

## Principle 2 — Simulation Must Be Modular

Circuit simulation, AVR simulation, firmware compilation, and the bridge should remain separate modules.

## Principle 3 — Components Must Be Extensible

New components should be addable without rewriting the entire simulator.

## Principle 4 — MCU Must Be Modular

The architecture should allow future microcontrollers.

```text
MCU Interface
     │
 ┌───┼────────┐
 │   │        │
32   16       328P
```

## Principle 5 — Offline First

The core workflow should not depend on cloud infrastructure.

---

# 44. Development Roadmap

# Phase 0 — Feasibility

## Objective

Prove that the core AVR simulation stack works on Android.

## Tasks

- Create Android NDK test project.
- Integrate AVR emulator.
- Configure ATmega32.
- Load known firmware ELF.
- Execute firmware.
- Observe GPIO.
- Observe UART.

## Success Criterion

```text
Android
   ↓
AVR Emulator
   ↓
ATmega32
   ↓
Firmware
   ↓
Observable GPIO/UART Output
```

---

# Phase 1 — AVR Firmware Toolchain

## Objective

Compile AVR firmware directly on Android.

## Tasks

- Integrate/build AVR-GCC.
- Integrate AVR Libc.
- Implement compiler execution.
- Handle compiler output.
- Handle compiler errors.
- Generate ELF.
- Load ELF into emulator.

## Success Criterion

A C program compiled entirely on Android executes correctly on the virtual ATmega32.

---

# Phase 2 — Circuit Simulation Engine

## Objective

Implement basic circuit simulation.

## First Circuit

```text
VCC → Resistor → LED → GND
```

## Second Circuit

```text
VCC → Potentiometer → GND
                    ↓
                 Analog Node
```

## Tasks

- Component representation
- Net representation
- Netlist generation
- Solver integration
- Voltage calculation
- Current calculation
- Component state updates

---

# Phase 3 — MCU ↔ Circuit Bridge

## Objective

Connect firmware execution to the circuit simulation.

## First Test

```text
ATmega32 PB0
     ↓
Resistor
     ↓
LED
     ↓
GND
```

Firmware:

```c
PORTB |= (1 << PB0);
```

Expected:

```text
PB0 HIGH
   ↓
MCU Bridge
   ↓
Circuit Net
   ↓
LED ON
```

## Second Test

```text
Potentiometer
      ↓
ADC0
      ↓
Firmware
      ↓
PB0
      ↓
LED
```

---

# Phase 4 — Schematic UI

## Objective

Build the visual circuit editor.

## Tasks

1. Canvas
2. Grid
3. Zoom
4. Pan
5. Component placement
6. Component selection
7. Component movement
8. Rotation
9. Wiring
10. Delete
11. Cut
12. Copy
13. Paste
14. Properties
15. Component library
16. Project panel
17. 3×3 tool pad
18. Simulation controls

---

# Phase 5 — Firmware UX

## Objective

Make firmware import and compilation usable through the UI.

Workflow:

```text
Select ATmega32
      ↓
Firmware
      ↓
Import Project
      ↓
Build
      ↓
Build Output
      ↓
Load Firmware
      ↓
Run Simulation
```

Required UI information:

- Build status
- Compiler output
- Errors
- Warnings
- Firmware path
- ELF path
- MCU status

---

# Phase 6 — Component Expansion

Expand the component library gradually.

Priority:

```text
MVP Components
      ↓
Digital Components
      ↓
Analog Components
      ↓
Sensors
      ↓
Displays
      ↓
Motors
      ↓
Communication Devices
      ↓
Additional MCUs
```

---

# 45. MVP Definition

The MVP is successful when the following complete workflow works:

```text
Create Project
      ↓
Place ATmega32
      ↓
Place Resistor
      ↓
Place LED
      ↓
Place GND
      ↓
Wire Circuit
      ↓
Import AVR C Firmware
      ↓
Compile Locally
      ↓
Generate ELF
      ↓
Load ELF
      ↓
Run Simulation
      ↓
ATmega32 GPIO Changes
      ↓
LED Responds
```

---

# 46. Minimum Working Circuit

```text
                 ┌──────────────┐
                 │   ATmega32   │
                 │              │
                 │          PB0 ├──── Resistor ─── LED ─── GND
                 │              │
                 └──────────────┘
```

This circuit is the primary proof-of-concept for the complete architecture.

---

# 47. MVP Component Set

The minimum component library should contain:

| Component | Purpose |
|---|---|
| ATmega32 | Microcontroller |
| Resistor | Current limiting |
| LED | Visual output |
| Push Button | Digital input |
| Switch | Digital input/control |
| Potentiometer | Analog input |
| Capacitor | Basic analog circuit |
| Diode | Semiconductor |
| VCC | Power |
| GND | Ground |
| DC Voltage Source | Power source |

---

# 48. MVP Firmware Example

A simple firmware test should control an LED connected to PB0.

```c
#include <avr/io.h>

int main(void)
{
    DDRB |= (1 << PB0);

    while (1)
    {
        PORTB |= (1 << PB0);
    }

    return 0;
}
```

Expected simulation:

```text
Firmware
   ↓
PB0 HIGH
   ↓
Virtual ATmega32
   ↓
MCU Bridge
   ↓
Resistor
   ↓
LED
   ↓
ON
```

A second firmware test should toggle the pin.

```c
#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    DDRB |= (1 << PB0);

    while (1)
    {
        PORTB ^= (1 << PB0);
        _delay_ms(500);
    }

    return 0;
}
```

Expected result:

```text
LED
ON
 ↓
OFF
 ↓
ON
 ↓
OFF
```

---

# 49. Testing Strategy

Testing should occur at four levels.

## 49.1 Unit Testing

Test:

- Component models
- Netlist generation
- Compiler configuration
- Project serialization
- Pin mapping
- Simulation state
- Component properties

## 49.2 Engine Testing

Test:

- AVR execution
- Circuit solver
- GPIO behavior
- ADC behavior
- PWM behavior
- UART behavior
- Digital transitions
- Analog values

## 49.3 Integration Testing

Example:

```text
Firmware
   ↓
PB0 HIGH
   ↓
MCU Bridge
   ↓
Circuit
   ↓
LED ON
```

Another example:

```text
Button
   ↓
Circuit
   ↓
MCU Bridge
   ↓
GPIO
   ↓
Firmware
   ↓
LED
```

## 49.4 UI Testing

Test:

- Component placement
- Component movement
- Wiring
- Selection
- Rotation
- Delete
- Copy/paste
- Save/load
- Panel behavior
- Simulation controls

---

# 50. Performance Testing

The application should be tested under different circuit sizes.

Example:

```text
Test A
10 components

Test B
50 components

Test C
100 components

Test D
500+ components
```

Measure:

- Startup time
- Memory usage
- CPU usage
- Simulation speed
- UI frame rate
- Project loading time
- Project saving time

---

# 51. Error Handling

The application should provide clear errors for:

## Firmware Errors

- Invalid source
- Missing header
- Compiler failure
- Linker failure
- Unsupported MCU
- Invalid build configuration

## Circuit Errors

- Floating nodes
- Invalid connections
- Missing ground
- Invalid component parameters
- Solver convergence failure

## Simulation Errors

- Unsupported peripheral
- Firmware loading failure
- MCU initialization failure
- Simulation engine failure

Example:

```text
Simulation Error

The circuit solver could not converge.

Possible causes:
• Invalid component configuration
• Floating node
• Missing power connection

[View Details]
```

---

# 52. Security Considerations

Imported firmware should be treated as untrusted input.

The application should:

- Restrict filesystem access.
- Keep compilation within the application's sandbox.
- Prevent imported projects from executing arbitrary Android applications.
- Validate project files.
- Restrict compiler execution to controlled binaries and arguments.
- Avoid granting unnecessary permissions.

Firmware should only execute inside the AVR simulation environment.

---

# 53. Resource Management

The application should avoid unnecessary background processes.

Simulation should consume resources only when required.

When simulation is stopped:

```text
Simulation
     ↓
Stop
     ↓
Release Emulator Resources
     ↓
Release Solver Resources
```

Large projects should be loaded incrementally where practical.

---

# 54. Future Architecture

The long-term architecture should support:

```text
                 dyamm-AVR Schema design
                    │
        ┌───────────┼───────────┐
        │           │           │
     ATmega32    ATmega16   ATmega328P
        │           │           │
        └───────────┼───────────┘
                    │
             MCU Interface
                    │
             Circuit Bridge
                    │
             Circuit Engine
```

This allows the platform to expand beyond ATmega32.

---

# 55. Future Features

Potential future functionality:

## MCU Support

- More AVR MCUs
- Arduino-compatible MCUs
- Other architectures

## Simulation

- Advanced analog simulation
- Advanced transient analysis
- Oscilloscope
- Logic analyzer
- Waveform viewer

## Debugging

- Breakpoints
- Register viewer
- Memory viewer
- GPIO monitor
- Peripheral monitor
- Instruction stepping

## Components

- More sensors
- Displays
- Motors
- Communication modules
- Logic ICs
- Timers
- Op-amps

## Project Features

- Templates
- Component libraries
- Project export
- Project import
- Sharing
- Version history

---

# 56. Non-Functional Requirements

## Reliability

The simulator should provide consistent simulation results for supported components and configurations.

## Usability

A new user should be able to create a basic circuit without extensive documentation.

## Maintainability

The codebase should use modular components and clearly separated responsibilities.

## Extensibility

Adding a new component should not require changes throughout the entire application.

## Portability

The simulation engine should remain as platform-independent as practical.

## Performance

Simulation and rendering should be optimized for Android hardware.

---

# 57. Repository Structure

Recommended repository:

```text
dyamm-AVR Schema design/
│
├── app/
│   └── Flutter Android application
│
├── native/
│   ├── avr/
│   │   ├── emulator/
│   │   └── atmega32/
│   │
│   ├── compiler/
│   │   ├── avr-gcc/
│   │   └── build/
│   │
│   ├── circuit/
│   │   ├── solver/
│   │   ├── components/
│   │   └── netlist/
│   │
│   └── bridge/
│       ├── gpio/
│       ├── adc/
│       ├── pwm/
│       └── peripherals/
│
├── engine/
│   ├── model/
│   ├── project/
│   ├── simulation/
│   └── serialization/
│
├── assets/
│   ├── symbols/
│   ├── components/
│   └── icons/
│
├── tests/
│   ├── unit/
│   ├── integration/
│   └── simulation/
│
├── docs/
│
├── scripts/
│
├── CMakeLists.txt
│
└── README.md
```

---

# 58. Development Priority

Development should follow this order:

```text
1. ATmega32 Emulator Proof
          ↓
2. AVR-GCC on Android
          ↓
3. ELF → ATmega32
          ↓
4. Basic Circuit Solver
          ↓
5. GPIO → LED Bridge
          ↓
6. ADC → Firmware Bridge
          ↓
7. Basic Schematic Editor
          ↓
8. Firmware UX
          ↓
9. Component Expansion
          ↓
10. Advanced Simulation
```

The UI should **not** be the first major development task.

---

# 59. First Technical Milestone

The first technical milestone is:

> Run an actual ATmega32 firmware ELF on Android and observe a GPIO output.

Required pipeline:

```text
Android
   ↓
Native C/C++
   ↓
AVR Emulator
   ↓
ATmega32
   ↓
ELF Firmware
   ↓
GPIO
```

Once this works, the next milestone is:

```text
Android
   ↓
AVR-GCC
   ↓
ELF
   ↓
AVR Emulator
   ↓
ATmega32
   ↓
GPIO
```

Then:

```text
ATmega32
   ↓
GPIO
   ↓
MCU Bridge
   ↓
Resistor
   ↓
LED
```

Only after these three milestones are successful should full schematic-editor development begin.

---

# 60. Definition of Done — MVP

The MVP is complete when:

- [ ] Android application launches successfully.
- [ ] 2D schematic canvas works.
- [ ] Grid works.
- [ ] Components can be placed.
- [ ] Components can be moved.
- [ ] Components can be rotated.
- [ ] Components can be wired.
- [ ] Components can be deleted.
- [ ] Components can be copied and pasted.
- [ ] ATmega32 is supported.
- [ ] AVR firmware can be imported.
- [ ] AVR-GCC runs locally.
- [ ] AVR C firmware can be compiled.
- [ ] ELF firmware can be generated.
- [ ] ELF firmware can be loaded into the ATmega32 emulator.
- [ ] ATmega32 executes firmware.
- [ ] GPIO state can be exposed to the circuit engine.
- [ ] Resistor/LED circuit can be simulated.
- [ ] Firmware can control a simulated LED.
- [ ] Digital input can reach firmware.
- [ ] Basic ADC interaction works.
- [ ] Projects can be saved.
- [ ] Projects can be reopened.
- [ ] Simulation can be started.
- [ ] Simulation can be paused.
- [ ] Simulation can be stopped.
- [ ] Simulation can be reset.

---

# 61. Success Criteria

The project will be considered technically successful if a user can perform the following entirely on Android:

```text
Create Circuit
      ↓
Add ATmega32
      ↓
Connect LED
      ↓
Import C Firmware
      ↓
Compile Using AVR-GCC
      ↓
Generate ELF
      ↓
Load Firmware
      ↓
Run Simulation
      ↓
Firmware Changes GPIO
      ↓
LED Changes State
```

The complete process should occur without requiring a PC or cloud service.

---

# 62. Key Technical Risks

## 62.1 AVR-GCC on Android

Packaging and executing the AVR-GCC toolchain directly on Android is a major technical challenge.

This should be investigated during Phase 0/Phase 1.

## 62.2 Circuit Solver

The selected circuit solver must provide:

- Android compatibility
- Adequate performance
- Required simulation capabilities
- Suitable licensing

## 62.3 MCU/Circuit Synchronization

The circuit solver and MCU emulator operate using different simulation models and potentially different time steps.

A robust synchronization strategy will therefore be required.

## 62.4 Performance

Large circuits may require significant CPU and memory resources.

## 62.5 Third-Party Licensing

All external components and libraries must be reviewed before redistribution.

Particular attention should be given to:

- AVR emulator licensing
- Circuit solver licensing
- AVR-GCC redistribution
- AVR Libc
- Android native dependencies

---

# 63. Technical Decision Requirements

Before implementation is finalized, the following decisions must be experimentally validated:

1. AVR emulator integration method.
2. AVR-GCC Android execution strategy.
3. Circuit solver selection.
4. MCU/circuit synchronization model.
5. Native engine API.
6. Flutter ↔ native communication method.
7. Project file format.
8. Component serialization format.
9. Simulation time-step strategy.
10. Third-party licensing and redistribution requirements.

---

# 64. Architectural Goal

The final architecture should resemble:

```text
┌─────────────────────────────────────────────┐
│                 dyamm-AVR Schema design App                  │
├─────────────────────────────────────────────┤
│                                             │
│                Flutter UI                   │
│                                             │
├─────────────────────────────────────────────┤
│             Application Layer               │
│                                             │
│ Projects │ Components │ Simulation │ Build  │
│                                             │
├─────────────────────────────────────────────┤
│              Native Engine                  │
│                                             │
│  Circuit Solver                             │
│       │                                     │
│       ├──── MCU ↔ Circuit Bridge ────┐      │
│       │                              │      │
│  Netlist                        AVR Engine  │
│                                      │      │
│                                 ATmega32    │
│                                      │      │
│                                  Firmware   │
│                                             │
├─────────────────────────────────────────────┤
│               Toolchain                     │
│                                             │
│ AVR-GCC │ AVR Libc │ ELF │ HEX              │
│                                             │
└─────────────────────────────────────────────┘
```

---

# 65. Product Philosophy

dyamm-AVR Schema design should follow these principles:

### Engineering First

Simulation capability is more important than visual effects.

### Lightweight

The application should remain usable on normal Android devices.

### Offline First

The core workflow should work without an internet connection.

### Modular

Every major system should have a clear responsibility.

### Extensible

The architecture should allow additional MCUs and components.

### Practical

The simulator should focus on useful embedded-system workflows rather than attempting to reproduce every feature of professional EDA software.

### Real Firmware

The application should execute actual compiled AVR firmware rather than merely visually approximating MCU behavior.

---

# 66. Final Product Concept

dyamm-AVR Schema design is essentially:

```text
             2D Circuit Simulator
                     +
             AVR Firmware Toolchain
                     +
             ATmega32 Emulator
                     +
            Circuit/MCU Bridge
                     +
             Android Application
```

The defining feature is the interaction between **real compiled firmware** and a **simulated electronic circuit**.

The fundamental pipeline is:

```text
        AVR C Firmware
              ↓
           AVR-GCC
              ↓
             ELF
              ↓
        Virtual ATmega32
              ↓
       MCU/Circuit Bridge
              ↓
      Simulated Electronics
              ↓
       Observable Behavior
```

This pipeline is the core technical identity of the product.

---

# 67. Immediate Next Step

The first development task should **not** be the complete UI.

Start with a minimal Android native proof of concept:

```text
Android NDK Project
        ↓
     dyamm-AVR Schema design
        ↓
    ATmega32
        ↓
Known ELF Firmware
        ↓
    GPIO Output
```

Once this succeeds:

```text
AVR-GCC
   ↓
ELF
   ↓
dyamm-AVR Schema design
   ↓
ATmega32
```

Then:

```text
ATmega32 PB0
      ↓
Digital Bridge
      ↓
LED Model
      ↓
LED ON/OFF
```

That gives the project its first genuinely working simulation loop before the complexity of the full schematic editor is introduced.