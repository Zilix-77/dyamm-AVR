import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sim_state.dart';

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
