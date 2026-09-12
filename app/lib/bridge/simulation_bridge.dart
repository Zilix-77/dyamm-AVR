/// MCU <-> circuit sync bridge (PRD §17). FFI-backed later.
abstract class McuBridge {
  Future<void> syncGpio(Map<String, bool> gpio);
  Future<double> readAdc(int channel);
}
