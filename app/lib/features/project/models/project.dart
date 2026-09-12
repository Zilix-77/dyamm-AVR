import 'package:flutter/foundation.dart';

import '../../../features/components/models/component.dart';

/// Project data model (PRD §39, §40). Serialized as .dyamm JSON.
@immutable
class Wire {
  final String id;
  final String fromComponent;
  final String fromPin;
  final String toComponent;
  final String toPin;
  const Wire({
    required this.id,
    required this.fromComponent,
    required this.fromPin,
    required this.toComponent,
    required this.toPin,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'from': '$fromComponent.$fromPin',
        'to': '$toComponent.$toPin',
      };
}

@immutable
class Project {
  final String name;
  final List<Component> components;
  final List<Wire> wires;
  const Project({required this.name, this.components = const [], this.wires = const []});

  Map<String, dynamic> toJson() => {
        'name': name,
        'components': [for (final c in components) c.toJson()],
        'wires': [for (final w in wires) w.toJson()],
      };
}
