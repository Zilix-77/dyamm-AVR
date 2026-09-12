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

  factory Wire.fromJson(Map<String, dynamic> j) {
    final from = (j['from'] as String).split('.');
    final to = (j['to'] as String).split('.');
    return Wire(
      id: j['id'] as String,
      fromComponent: from[0],
      fromPin: from.length > 1 ? from[1] : '',
      toComponent: to[0],
      toPin: to.length > 1 ? to[1] : '',
    );
  }
}

@immutable
class Project {
  final String name;
  final List<Component> components;
  final List<Wire> wires;
  const Project({
    required this.name,
    this.components = const [],
    this.wires = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'components': [for (final c in components) c.toJson()],
        'wires': [for (final w in wires) w.toJson()],
      };

  factory Project.fromJson(Map<String, dynamic> j) => Project(
        name: j['name'] as String,
        components: [
          for (final c in (j['components'] as List? ?? []))
            Component.fromJson(Map<String, dynamic>.from(c as Map)),
        ],
        wires: [
          for (final w in (j['wires'] as List? ?? []))
            Wire.fromJson(Map<String, dynamic>.from(w as Map)),
        ],
      );
}
