import 'package:flutter/foundation.dart';

/// Common component abstraction (PRD §23, §40).
/// MVP set (PRD §47) plus Stitch tiles (inductor, relay, transformer).
enum ComponentType {
  atmega32,
  resistor,
  led,
  pushButton,
  switch_,
  potentiometer,
  capacitor,
  diode,
  inductor,
  relay,
  transformer,
  vcc,
  gnd,
  dcSource,
}

/// DC-simulation support per type. Render-only types draw but don't stamp.
enum SimSupport { full, open, short, none }

@immutable
class Pin {
  final String id;
  final String label;

  /// Symbol-relative offset in grid units (symbol ~2 wide, 1 tall).
  final double dx;
  final double dy;

  const Pin({required this.id, required this.label, this.dx = 0, this.dy = 0});

  Map<String, dynamic> toJson() =>
      {'id': id, 'label': label, 'dx': dx, 'dy': dy};

  factory Pin.fromJson(Map<String, dynamic> j) => Pin(
        id: j['id'] as String,
        label: j['label'] as String? ?? '',
        dx: (j['dx'] as num?)?.toDouble() ?? 0,
        dy: (j['dy'] as num?)?.toDouble() ?? 0,
      );
}

@immutable
class Component {
  final String id;
  final ComponentType type;
  final double x;
  final double y;
  final int rotation; // 0/90/180/270
  final Map<String, double> properties;
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

  Component copyWith({
    String? id,
    double? x,
    double? y,
    int? rotation,
    Map<String, double>? properties,
    List<Pin>? pins,
  }) =>
      Component(
        id: id ?? this.id,
        type: type,
        x: x ?? this.x,
        y: y ?? this.y,
        rotation: rotation ?? this.rotation,
        properties: properties ?? this.properties,
        pins: pins ?? this.pins,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'x': x,
        'y': y,
        'rotation': rotation,
        'properties': properties,
        'pins': [for (final p in pins) p.toJson()],
      };

  factory Component.fromJson(Map<String, dynamic> j) => Component(
        id: j['id'] as String,
        type: ComponentType.values.byName(j['type'] as String),
        x: (j['x'] as num?)?.toDouble() ?? 0,
        y: (j['y'] as num?)?.toDouble() ?? 0,
        rotation: (j['rotation'] as num?)?.toInt() ?? 0,
        properties: {
          for (final e in (j['properties'] as Map? ?? {}).entries)
            e.key as String: (e.value as num).toDouble(),
        },
        pins: [
          for (final p in (j['pins'] as List? ?? []))
            Pin.fromJson(Map<String, dynamic>.from(p as Map)),
        ],
      );
}

/// Per-type catalog data: defaults for placement + DC solver support.
class ComponentSpec {
  final Map<String, double> defaultProperties;
  final List<Pin> defaultPins;
  final SimSupport simSupport;
  const ComponentSpec({
    this.defaultProperties = const {},
    this.defaultPins = const [],
    this.simSupport = SimSupport.none,
  });
}

const Pin _pa = Pin(id: 'a', label: 'A', dx: -1);
const Pin _pb = Pin(id: 'b', label: 'B', dx: 1);
const Pin _panode = Pin(id: 'a', label: 'A', dx: -1);
const Pin _pkath = Pin(id: 'b', label: 'K', dx: 1);

const Map<ComponentType, ComponentSpec> componentSpecs = {
  ComponentType.resistor: ComponentSpec(
    defaultProperties: {'resistance': 220},
    defaultPins: [_pa, _pb],
    simSupport: SimSupport.full,
  ),
  ComponentType.led: ComponentSpec(
    defaultProperties: {'vf': 2.0, 'ron': 10},
    defaultPins: [_panode, _pkath],
    simSupport: SimSupport.full,
  ),
  ComponentType.diode: ComponentSpec(
    defaultProperties: {'vf': 0.7, 'ron': 10},
    defaultPins: [_panode, _pkath],
    simSupport: SimSupport.full,
  ),
  // DC steady state: open circuit.
  ComponentType.capacitor: ComponentSpec(
    defaultProperties: {'capacitance': 100e-9},
    defaultPins: [_pa, _pb],
    simSupport: SimSupport.open,
  ),
  // DC steady state: short circuit.
  ComponentType.inductor: ComponentSpec(
    defaultProperties: {'inductance': 10e-3},
    defaultPins: [_pa, _pb],
    simSupport: SimSupport.short,
  ),
  ComponentType.pushButton: ComponentSpec(
    defaultProperties: {'closed': 0},
    defaultPins: [_pa, _pb],
    simSupport: SimSupport.full,
  ),
  ComponentType.switch_: ComponentSpec(
    defaultProperties: {'closed': 0},
    defaultPins: [_pa, _pb],
    simSupport: SimSupport.full,
  ),
  ComponentType.vcc: ComponentSpec(
    defaultProperties: {'voltage': 5.0},
    defaultPins: [Pin(id: 'p', label: '+')],
    simSupport: SimSupport.full,
  ),
  ComponentType.gnd: ComponentSpec(
    defaultPins: [Pin(id: 'p', label: '')],
    simSupport: SimSupport.full,
  ),
  ComponentType.dcSource: ComponentSpec(
    defaultProperties: {'voltage': 5.0},
    defaultPins: [
      Pin(id: 'p', label: '+', dx: -1),
      Pin(id: 'n', label: '-', dx: 1),
    ],
    simSupport: SimSupport.full,
  ),
  ComponentType.potentiometer: ComponentSpec(
    defaultProperties: {'resistance': 10000, 'wiper': 0.5},
    defaultPins: [
      Pin(id: 'h', label: 'H', dx: -1),
      Pin(id: 'w', label: 'W', dy: 1),
      Pin(id: 'l', label: 'L', dx: 1),
    ],
  ),
  ComponentType.atmega32: ComponentSpec(simSupport: SimSupport.full),
  ComponentType.relay: ComponentSpec(),
  ComponentType.transformer: ComponentSpec(),
};

/// Factory for placement: spec defaults + caller position.
Component makeComponent(String id, ComponentType type, double x, double y) {
  final spec = componentSpecs[type]!;
  return Component(
    id: id,
    type: type,
    x: x,
    y: y,
    properties: Map.of(spec.defaultProperties),
    pins: spec.defaultPins,
  );
}
