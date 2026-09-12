import 'package:flutter/foundation.dart';

/// Common component abstraction (PRD §23, §40).
/// MVP set (PRD §47): atmega32, resistor, led, button, switch,
/// potentiometer, capacitor, diode, vcc, gnd, dc_source.
enum ComponentType {
  atmega32,
  resistor,
  led,
  pushButton,
  switch_,
  potentiometer,
  capacitor,
  diode,
  vcc,
  gnd,
  dcSource,
}

@immutable
class Pin {
  final String id;
  final String label;
  const Pin({required this.id, required this.label});
}

@immutable
class Component {
  final String id;
  final ComponentType type;
  final double x;
  final double y;
  final int rotation; // 0/90/180/270
  final Map<String, double> properties; // e.g. resistance, capacitance
  final List<Pin> pins;

  const Component({
    required this.id,
    required this.type,
    this.x = 0,
    this.y = 0,
    this.rotation = 0,
    this.properties = const {},
    this.pins = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'x': x,
        'y': y,
        'rotation': rotation,
        'properties': properties,
        'pins': [for (final p in pins) {'id': p.id, 'label': p.label}],
      };
}
