import 'models/component.dart';

export 'models/component.dart';

/// MVP library entries (PRD §47), order shown in bottom strip.
const componentLibrary = [
  ComponentType.atmega32,
  ComponentType.resistor,
  ComponentType.capacitor,
  ComponentType.led,
  ComponentType.diode,
  ComponentType.pushButton,
  ComponentType.potentiometer,
  ComponentType.vcc,
  ComponentType.gnd,
];

String componentLabel(ComponentType t) => switch (t) {
  ComponentType.atmega32 => 'ATmega32',
  ComponentType.resistor => 'R',
  ComponentType.capacitor => 'C',
  ComponentType.led => 'LED',
  ComponentType.diode => 'Diode',
  ComponentType.pushButton => 'Btn',
  ComponentType.switch_ => 'SW',
  ComponentType.potentiometer => 'Pot',
  ComponentType.vcc => 'VCC',
  ComponentType.gnd => 'GND',
  ComponentType.dcSource => 'DC',
};
