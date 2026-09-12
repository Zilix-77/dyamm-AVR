import 'models/mcu.dart';

export 'models/mcu.dart';

/// ATmega32 stub — real exec lives in native/avr via FFI (PRD §15-§16).
class Atmega32 implements McuInterface {
  @override
  String get name => 'ATmega32';

  @override
  Future<void> loadElf(String elfPath) =>
      throw UnimplementedError('native AVR engine');

  @override
  Future<void> step() => throw UnimplementedError('native AVR engine');

  @override
  Map<String, bool> readGpio() => throw UnimplementedError('native AVR engine');
}
