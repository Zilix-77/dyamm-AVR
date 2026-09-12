# simavr Documentation Rule

## Implementation Documentation Policy

Documentation must stay synchronized with the actual implementation.

Do NOT generate implementation-specific documentation in advance based only on the PRD or planned architecture.

The following documentation files must be created and/or updated WHILE their corresponding systems are actually implemented:

> Paths below are relative to `app/` (e.g. `app/docs/simulation/AVR_SIMULATION.md`).

### Simulation

- `docs/simulation/AVR_SIMULATION.md`
- `docs/simulation/CIRCUIT_SOLVER.md`
- `docs/simulation/DIGITAL_ANALOG_BRIDGE.md`

### Firmware

- `docs/firmware/AVR_GCC_PIPELINE.md`
- `docs/firmware/ELF_HEX_HANDLING.md`

### Development

- `docs/development/BUILD_SYSTEM.md`
- `docs/development/NATIVE_BUILD.md`
- `docs/development/TESTING.md`
- `docs/development/DEBUGGING.md`

## Documentation Timing

Whenever implementing, modifying, or completing a feature covered by one of these documents:

1. Implement the feature.
2. Verify that the implementation works.
3. Update the corresponding documentation.
4. Document the ACTUAL implementation, not the originally planned implementation.
5. Include relevant commands, APIs, architecture details, configuration, limitations, and known issues.
6. Keep the documentation synchronized with the current code.

Documentation should be updated in the same development task/PR whenever practical.

## No Hallucinated Documentation

Never invent implementation details.

Do NOT document:

- APIs that do not exist
- Functions that have not been implemented
- Build commands that have not been tested
- Architecture that differs from the actual code
- Simulation behavior that has not been verified
- Compiler/toolchain behavior that has not been tested
- Performance numbers that have not been measured
- Features that are only planned

If something is planned but not implemented, explicitly mark it:

- `Planned`
- `TBD`
- `Not yet implemented`
- `To Be Verified`

Do not present planned behavior as implemented behavior.

## Source of Truth

Use the following hierarchy:

1. Actual source code and configuration
2. Verified test results
3. Actual build/run results
4. Official technical references and source documentation
5. Architecture/design documents
6. PRD

The PRD describes what we WANT to build.

The code describes what we HAVE built.

Implementation documentation must describe what we HAVE built.

If the implementation differs from the PRD, document the actual implementation and, when important, explain the difference.

## Required Documentation Mapping

When working on these areas, update the corresponding document:

| Implementation Area | Documentation |
|---|---|
| simavr integration / AVR emulation | `docs/simulation/AVR_SIMULATION.md` |
| Circuit solving / electrical simulation | `docs/simulation/CIRCUIT_SOLVER.md` |
| MCU ↔ circuit communication | `docs/simulation/DIGITAL_ANALOG_BRIDGE.md` |
| AVR-GCC compilation | `docs/firmware/AVR_GCC_PIPELINE.md` |
| ELF / HEX generation and handling | `docs/firmware/ELF_HEX_HANDLING.md` |
| Flutter ↔ Android ↔ native build system | `docs/development/BUILD_SYSTEM.md` |
| C/C++ / NDK / CMake native build | `docs/development/NATIVE_BUILD.md` |
| Automated/manual tests | `docs/development/TESTING.md` |
| Errors, failures, fixes and debugging procedures | `docs/development/DEBUGGING.md` |

## Documentation Requirements

When updating an implementation document, prefer documenting:

- Purpose
- Current implementation
- Relevant source files
- Important classes/functions/modules
- Data flow
- Build/configuration requirements
- Commands that were actually tested
- Inputs and outputs
- Dependencies
- Error handling
- Tests
- Known limitations
- Debugging information
- Future work

Do not add unnecessary documentation just for the sake of filling the file.

## Keep Documentation Incremental

Do not wait until the entire project is finished.

For example:

### Phase 1

Implement basic simavr integration.

Update:

`docs/simulation/AVR_SIMULATION.md`

Document only what currently works.

### Phase 1 (continued)

Add ATmega32 firmware loading.

Update:

`docs/simulation/AVR_SIMULATION.md`

and, if applicable:

`docs/firmware/ELF_HEX_HANDLING.md`

### Phase 2

Add AVR-GCC compilation.

Update:

`docs/firmware/AVR_GCC_PIPELINE.md`

### Phase 5

Add GPIO → circuit communication.

Update:

`docs/simulation/DIGITAL_ANALOG_BRIDGE.md`

Continue this process throughout development.

## Before Completing a Development Task

Before considering an implementation task complete, check:

- [ ] Code is implemented.
- [ ] Implementation has been tested where possible.
- [ ] Relevant documentation has been updated.
- [ ] Documentation reflects the actual code.
- [ ] No unverified technical claims were added.
- [ ] Planned features are clearly marked as planned/TBD.
- [ ] Build/test/debug instructions are based on commands that actually work.

## Important

Do not create all implementation documentation at project initialization merely because the files are listed in the PRD.

Create the files when their corresponding systems begin being implemented.

The goal is:

PRD
→ Architecture
→ Implementation
→ Verification
→ Documentation

NOT:

PRD
→ Speculative documentation
→ Implementation