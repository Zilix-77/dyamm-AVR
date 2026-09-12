import '../../../bridge/native_bridge.dart';
import '../models/firmware.dart';

export '../models/firmware.dart';

/// Firmware import (.c/.h/.zip, PRD §19) + compile pipeline (PRD §20).
abstract class ToolchainService {
  Future<List<String>> importProject(String path);
  Future<BuildOutput> build(BuildConfig config, List<String> sources);
  BuildConfigLike toBridge(BuildConfig c) =>
      BuildConfigLike(mcu: c.mcu, fCpu: c.fCpu, opt: c.opt);
}
