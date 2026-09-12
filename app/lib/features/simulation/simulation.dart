import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sim_state.dart';
import '../project/project_manager.dart';
import '../schematic/editor_state.dart';
import 'solver/mna_solver.dart';

export 'solver/mna_solver.dart';

/// Simulation controller (PRD §35). Native calls go through bridge/, never UI.
final simControllerProvider = NotifierProvider<SimController, SimState>(
  SimController.new,
);

class SimController extends Notifier<SimState> {
  @override
  SimState build() => SimState.stopped;

  void run() => state = SimState.running;
  void pause() => state = SimState.paused;
  void stop() => state = SimState.stopped;
}

/// Latest solver error, if any. Null means the last solve succeeded.
final simErrorProvider = StateProvider<String?>((ref) => null);

/// Re-runs the DC solver on the active project and publishes LED/diode
/// on-off states to [simStatesProvider]. Called by the canvas after every
/// structural edit. Solver-owned logic lives in `solver/mna_solver.dart`.
void refreshSimulation(WidgetRef ref) {
  final project = ref.read(sessionProvider).active;
  if (project == null) return;
  final solution = solveDc(project);
  ref.read(simStatesProvider.notifier).state =
      Map<String, bool>.of(solution.componentOn);
  ref.read(simErrorProvider.notifier).state = solution.error;
}
