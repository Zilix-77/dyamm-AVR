/// Build config + output (PRD §21-§22). MVP keeps it fixed:
/// ATmega32, 16 MHz, -Os, ELF.
class BuildConfig {
  final String mcu;
  final String fCpu;
  final String opt;
  const BuildConfig({this.mcu = 'atmega32', this.fCpu = '16000000UL', this.opt = '-Os'});
}

class BuildOutput {
  final bool success;
  final String log;
  final String? elfPath;
  const BuildOutput({required this.success, required this.log, this.elfPath});
}
