/// MCU abstraction so future MCUs plug in without rewrites (PRD §43-P4, §54).
abstract class McuInterface {
  String get name;
  Future<void> loadElf(String elfPath);
  Future<void> step();
  Map<String, bool> readGpio();
}
