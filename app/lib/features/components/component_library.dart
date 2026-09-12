import 'models/component.dart';

export 'models/component.dart';

/// Library entries in Stitch strip order. Render-only types (relay,
/// transformer, potentiometer, atmega32) draw tiles but carry no DC model yet.
const componentLibrary = [
  ComponentType.atmega32,
  ComponentType.resistor,
  ComponentType.capacitor,
  ComponentType.inductor,
  ComponentType.led,
  ComponentType.diode,
  ComponentType.pushButton,
  ComponentType.switch_,
  ComponentType.potentiometer,
  ComponentType.gnd,
  ComponentType.vcc,
  ComponentType.relay,
  ComponentType.transformer,
];

String componentLabel(ComponentType t) => switch (t) {
      ComponentType.atmega32 => 'ATmega32',
      ComponentType.resistor => 'Resistor',
      ComponentType.capacitor => 'Capacitor',
      ComponentType.inductor => 'Inductor',
      ComponentType.led => 'LED',
      ComponentType.diode => 'Diode',
      ComponentType.pushButton => 'Button',
      ComponentType.switch_ => 'Switch',
      ComponentType.potentiometer => 'Potentiom.',
      ComponentType.vcc => 'VCC',
      ComponentType.gnd => 'GND',
      ComponentType.dcSource => 'DC',
      ComponentType.relay => 'Relay',
      ComponentType.transformer => 'Transformer',
    };
