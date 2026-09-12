# CircuitForge — Development Roadmap

## PHASE 0 — Project Setup
- [ ] Initialize project structure
- [ ] Configure Flutter + Dart
- [ ] Configure Android native/C++ layer
- [ ] Configure CMake
- [ ] Set up Git repository
- [ ] Verify Android build
- [ ] Create initial app shell

---

## PHASE 1 — ATmega32 Emulator on Android
- [ ] Implement ATmega32 CPU core
- [ ] Implement registers
- [ ] Implement program counter
- [ ] Implement stack pointer
- [ ] Implement SRAM
- [ ] Implement Flash memory
- [ ] Implement EEPROM
- [ ] Implement status register (SREG)
- [ ] Implement instruction decoder
- [ ] Implement AVR instruction set
- [ ] Implement timers
- [ ] Implement GPIO
- [ ] Implement interrupts
- [ ] Add emulator tests
- [ ] Verify ATmega32 firmware execution

---

## PHASE 2 — AVR-GCC on Android
- [ ] Integrate AVR-GCC
- [ ] Integrate AVR-Libc
- [ ] Integrate GNU Binutils
- [ ] Configure native compilation environment
- [ ] Implement C/C++ firmware compilation
- [ ] Generate ELF output
- [ ] Generate HEX output
- [ ] Handle compiler errors
- [ ] Test compilation on Android

---

## PHASE 3 — Firmware → ATmega32
- [ ] Load HEX firmware into emulator Flash
- [ ] Parse Intel HEX
- [ ] Validate firmware
- [ ] Reset MCU after firmware upload
- [ ] Execute firmware
- [ ] Expose MCU state
- [ ] Add firmware debugging/logging
- [ ] Test real AVR firmware

---

## PHASE 4 — Circuit Simulation Engine
- [ ] Design circuit simulation architecture
- [ ] Implement component system
- [ ] Implement electrical nodes
- [ ] Implement connections/wires
- [ ] Implement voltage/current representation
- [ ] Implement digital logic simulation
- [ ] Implement resistor
- [ ] Implement LED
- [ ] Implement push button
- [ ] Implement power supply
- [ ] Implement ground
- [ ] Add simulation tick/update loop
- [ ] Add simulation state management
- [ ] Test circuit simulation

---

## PHASE 5 — MCU ↔ Circuit Bridge
- [ ] Connect MCU GPIO to circuit nodes
- [ ] Map MCU pins to simulation nodes
- [ ] Implement digital HIGH/LOW propagation
- [ ] Implement input detection
- [ ] Implement output propagation
- [ ] Implement GPIO direction handling
- [ ] Synchronize MCU and circuit simulation
- [ ] Test LED + GPIO
- [ ] Test button + GPIO
- [ ] Test multiple connected components

---

## PHASE 6 — Schematic Editor UI
- [ ] Create schematic canvas
- [ ] Implement pan
- [ ] Implement zoom
- [ ] Implement grid
- [ ] Implement component placement
- [ ] Implement component selection
- [ ] Implement component movement
- [ ] Implement wire creation
- [ ] Implement wire deletion
- [ ] Implement component deletion
- [ ] Implement snapping
- [ ] Implement pin visualization
- [ ] Implement component properties
- [ ] Add component toolbar
- [ ] Add simulation controls
- [ ] Test schematic editing

---

## PHASE 7 — Firmware UI
- [ ] Create firmware editor
- [ ] Add syntax highlighting
- [ ] Add file/project tabs
- [ ] Add compile button
- [ ] Add compile output panel
- [ ] Add error display
- [ ] Add HEX generation
- [ ] Add firmware upload button
- [ ] Connect editor to AVR-GCC
- [ ] Connect compiled firmware to emulator
- [ ] Add run/stop/reset controls

---

## PHASE 8 — Save/Load Projects
- [ ] Design project file format
- [ ] Save schematic
- [ ] Save component properties
- [ ] Save wire connections
- [ ] Save firmware source
- [ ] Save MCU configuration
- [ ] Load projects
- [ ] Validate project files
- [ ] Handle corrupted projects
- [ ] Add New Project
- [ ] Add Open Project
- [ ] Add Save Project
- [ ] Add Save As

---

## PHASE 9 — More Components
- [ ] 7-segment display
- [ ] RGB LED
- [ ] Buzzer
- [ ] Potentiometer
- [ ] Switch
- [ ] DIP switch
- [ ] LCD
- [ ] UART/Serial monitor
- [ ] Servo
- [ ] DC motor
- [ ] Transistor
- [ ] Capacitor
- [ ] Diode
- [ ] Additional logic gates
- [ ] Component library system

---

## PHASE 10 — Optimization + Release
- [ ] Profile CPU emulator
- [ ] Profile circuit simulation
- [ ] Optimize simulation loop
- [ ] Optimize memory usage
- [ ] Reduce Android binary size
- [ ] Improve UI performance
- [ ] Add crash handling
- [ ] Add error reporting
- [ ] Complete documentation
- [ ] Complete testing
- [ ] Test on low-end Android devices
- [ ] Test large circuits
- [ ] Test large firmware projects
- [ ] Prepare release build
- [ ] Create app icon
- [ ] Create screenshots
- [ ] Create release notes
- [ ] Final QA
- [ ] Release CircuitForge