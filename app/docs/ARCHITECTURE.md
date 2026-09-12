# dyamm-AVR Schema design — code map (PRD §9, §57)

- `lib/features/schematic/` canvas + tools (Phase 3)
- `lib/features/components/` MVP set §47
- `lib/features/mcu/` ATmega32 §15 (+ McuInterface for §54)
- `lib/bridge/` FFI + MethodChannel contracts (UI never touches native/)
- `lib/features/firmware/` import/build §19-§22
- `lib/features/simulation/` controls §35 + bridge sync §17
- `lib/features/project/` .dyamm JSON §39
- `native/` Phase 1+ engines (stubs until their implementation phase)
