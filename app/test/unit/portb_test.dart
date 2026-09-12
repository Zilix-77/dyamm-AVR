import 'package:dyamm_avr_schema_design/bridge/native_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PortB unpacks (pin << 16) | (ddr << 8) | port', () {
    // PB0 out + high: port=0x01, ddr=0x01, pin=0x01.
    const packed = (0x01 << 16) | (0x01 << 8) | 0x01;
    final pb = PortB.unpack(packed);
    expect(pb.port, 0x01);
    expect(pb.ddr, 0x01);
    expect(pb.pin, 0x01);
    expect(pb.pinHigh(0), isTrue);
    expect(pb.pinHigh(1), isFalse);
  });
}
