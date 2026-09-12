import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/firmware.dart';

export 'models/firmware.dart';

/// Firmware UI state: sources + last build output (PRD Phase 5 UX).
final firmwareManagerProvider =
    NotifierProvider<FirmwareManager, FirmwareState>(FirmwareManager.new);

class FirmwareState {
  final List<String> sources;
  final BuildOutput? lastBuild;
  const FirmwareState({this.sources = const [], this.lastBuild});
}

class FirmwareManager extends Notifier<FirmwareState> {
  @override
  FirmwareState build() => const FirmwareState();

  void setSources(List<String> s) => state = FirmwareState(sources: s, lastBuild: state.lastBuild);
  void setBuild(BuildOutput b) => state = FirmwareState(sources: state.sources, lastBuild: b);
}
