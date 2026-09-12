import 'package:dyamm_avr_schema_design/bridge/native_bridge.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('simavr/emulator');
  final calls = <MethodCall>[];
  int portBReply = (0x01 << 16) | (0x01 << 8) | 0x01;
  bool nullReply = false;

  setUp(() {
    calls.clear();
    portBReply = (0x01 << 16) | (0x01 << 8) | 0x01;
    nullReply = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (nullReply) return null;
      return switch (call.method) {
        'isAvailable' => true,
        'init' => 42,
        'loadHex' => 0,
        'runCycles' => 1,
        'getPortB' => portBReply,
        'loadHexBytes' => 0,
        'terminate' => null,
        _ => throw PlatformException(code: 'UNIMPL'),
      };
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('marshals init/loadHex/runCycles/getPortB/terminate', () async {
    final engine = MethodChannelAvrEngine();
    expect(await engine.isAvailable(), isTrue);
    expect(await engine.init(), 42);
    expect(await engine.loadHex(42, '/x.hex'), 0);
    expect(await engine.runCycles(42, 10), 1);
    final pb = await engine.getPortB(42);
    expect(pb?.pinHigh(0), isTrue);
    await engine.terminate(42);
    expect(calls.map((c) => c.method), [
      'isAvailable',
      'init',
      'loadHex',
      'runCycles',
      'getPortB',
      'terminate'
    ]);
    final load = calls[2];
    expect(load.arguments['handle'], 42);
    expect(load.arguments['path'], '/x.hex');
  });

  test('getPortB returns null on native error, never all-high', () async {
    portBReply = -1;
    final pb = await MethodChannelAvrEngine().getPortB(42);
    expect(pb, isNull);
  });

  test('null channel reply throws NativeException', () async {
    nullReply = true;
    await expectLater(MethodChannelAvrEngine().init(),
        throwsA(isA<NativeException>()));
  });

  test('loadHexBytes marshals handle and byte array', () async {
    final engine = MethodChannelAvrEngine();
    expect(await engine.loadHexBytes(42, [0xB8, 0x9A]), 0);
    final call = calls.singleWhere((c) => c.method == 'loadHexBytes');
    expect(call.arguments['handle'], 42);
    expect((call.arguments['bytes'] as Uint8List).toList(), [0xB8, 0x9A]);
  });
}
