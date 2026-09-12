/// FFI-side engine contracts (hot loop). MethodChannel only for toolchain.
abstract class AvrEngine {
  Future<void> loadElf(String path);
  Future<Map<String, bool>> readGpio();
}

abstract class CircuitSolver {
  Future<Map<String, double>> solve(Map<String, dynamic> netlist);
}

abstract class Toolchain {
  Future<String> compile(BuildConfigLike config, List<String> sources);
}

/// Minimal config view to avoid firmware <-> bridge import cycle.
class BuildConfigLike {
  final String mcu;
  final String fCpu;
  final String opt;
  const BuildConfigLike({
    required this.mcu,
    required this.fCpu,
    required this.opt,
  });
}
