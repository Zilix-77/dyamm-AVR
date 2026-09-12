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
