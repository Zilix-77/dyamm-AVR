# App Architecture (Flutter)

> Source: PRD §§9, 11, 43. Code: `lib/`.

## Data flow (unidirectional)
```text
View (features/*/widgets) → ViewModel/Manager (Riverpod Notifier)
→ Repository/Manager (SSOT) → bridge/* → native/
```
UI never imports `dart:ffi` or channels; only `bridge/` does. Repos own mutation; views render.

## Feature layout
Each feature owns `models/ + services/ + *_manager.dart` (Riverpod `NotifierProvider`):
`schematic` (canvas state) · `components` (library) · `mcu` (`McuInterface`) ·
`simulation` (run/pause/stop) · `firmware` (sources + build output) · `project` (components + wires).

## Core
`core/constants` (grid/scale) · `core/utils` (JSON helpers) · `core/models` (`Result<T>` for §51
errors) · `core/services` (`StorageService`, offline JSON) · `core/sim_state.dart`.

## Native boundary
`bridge/native_bridge.dart`: `AvrEngine`, `CircuitSolver`, `Toolchain` ·
`bridge/simulation_bridge.dart`: `McuBridge`. All throw `UnimplementedError` until Phase 0–3.
