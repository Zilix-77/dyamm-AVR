import 'dart:ui' show Size;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/models/component.dart';
import 'models/schematic.dart';

/// Active editor tool (default: select).
final activeToolProvider =
    StateProvider<SchematicTool>((ref) => SchematicTool.select);

/// Selected component id, if any.
final selectedIdProvider = StateProvider<String?>((ref) => null);

/// Component type awaiting canvas-tap placement, if any.
final pendingPlacementProvider =
    StateProvider<ComponentType?>((ref) => null);

/// First wire endpoint (componentId.pinId) awaiting the second tap, if any.
final pendingWireProvider = StateProvider<String?>((ref) => null);

/// Live LED/diode on/off states from the last solver run, by component id.
final simStatesProvider =
    StateProvider<Map<String, bool>>((ref) => const {});

/// Canvas grid visibility (session-scoped: persists while editing).
final showGridProvider = StateProvider<bool>((ref) => true);

/// Snap-to-grid for placement and moves (session-scoped).
final snapEnabledProvider = StateProvider<bool>((ref) => true);

/// Rendered canvas size in logical pixels (reported post-frame by the canvas).
/// Used by the minimap for viewport math; null before first layout.
final canvasSizeProvider = StateProvider<Size?>((ref) => null);

/// Bumped on every history-stack change so undo/redo buttons rebuild.
final historyVersionProvider = StateProvider<int>((ref) => 0);
