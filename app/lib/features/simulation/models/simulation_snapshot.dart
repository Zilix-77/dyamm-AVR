import '../../../core/sim_state.dart';

/// Observable snapshot for probes/monitors (PRD §36-§37).
class SimulationSnapshot {
  final SimState state;
  final Map<String, bool> gpio;
  final Map<int, int> adc;
  const SimulationSnapshot({
    required this.state,
    this.gpio = const {},
    this.adc = const {},
  });
}
