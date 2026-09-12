import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Phase 1 engine contract (HEX-first). ELF arrives with the libelf strategy.
/// Mirrors cpp/simavr_jni.c; packed PORTB layout is (pin << 16) | (ddr << 8) | port.
abstract class AvrEngine {
  Future<bool> isAvailable();
  Future<int> init();
  Future<int> loadHex(int handle, String path);

  /// Raw flash binary variant (no filesystem staging). Same return codes.
  Future<int> loadHexBytes(int handle, List<int> bytes);
  Future<int> runCycles(int handle, int cycles);
  Future<PortB?> getPortB(int handle);
  Future<void> terminate(int handle);
}

/// Thrown when the platform channel itself fails (null reply, missing plugin).
class NativeException implements Exception {
  final String method;
  final String detail;
  const NativeException(this.method, this.detail);

  @override
  String toString() => 'NativeException($method): $detail';
}

@immutable
class PortB {
  final int port;
  final int ddr;
  final int pin;
  const PortB({required this.port, required this.ddr, required this.pin});

  factory PortB.unpack(int packed) => PortB(
        port: packed & 0xff,
        ddr: (packed >> 8) & 0xff,
        pin: (packed >> 16) & 0xff,
      );

  bool pinHigh(int bit) => (pin & (1 << bit)) != 0;
}

class MethodChannelAvrEngine implements AvrEngine {
  static const _channel = MethodChannel('simavr/emulator');

  Future<int> _callInt(String method, [Map<String, Object>? args]) async {
    final value = await _channel.invokeMethod<int>(method, args);
    if (value == null) throw NativeException(method, 'null reply');
    return value;
  }

  @override
  Future<bool> isAvailable() async =>
      await _channel.invokeMethod<bool>('isAvailable') ?? false;

  @override
  Future<int> init() => _callInt('init');

  /// Returns 0 on success; negative codes from simavr_jni.c:
  /// -1 bad handle/path, -2 unreadable file, -3 empty decode, -4 alloc failure.
  @override
  Future<int> loadHex(int handle, String path) =>
      _callInt('loadHex', {'handle': handle, 'path': path});

  @override
  Future<int> loadHexBytes(int handle, List<int> bytes) => _callInt(
      'loadHexBytes', {'handle': handle, 'bytes': Uint8List.fromList(bytes)});

  /// Returns the simavr run state; -1 for bad handle/cycles.
  @override
  Future<int> runCycles(int handle, int cycles) =>
      _callInt('runCycles', {'handle': handle, 'cycles': cycles});

  /// Returns null when native reports an error (negative packed value),
  /// so failures can never unpack to all-high pins.
  @override
  Future<PortB?> getPortB(int handle) async {
    final packed = await _callInt('getPortB', {'handle': handle});
    if (packed < 0) return null;
    return PortB.unpack(packed);
  }

  @override
  Future<void> terminate(int handle) =>
      _channel.invokeMethod<void>('terminate', {'handle': handle});
}

final avrEngineProvider =
    Provider<AvrEngine>((ref) => MethodChannelAvrEngine());

/// Minimal config view to avoid firmware <-> bridge import cycle.
class BuildConfigLike {
  final String mcu;
  final String fCpu;
  final String opt;
  const BuildConfigLike(
      {required this.mcu, required this.fCpu, required this.opt});
}
