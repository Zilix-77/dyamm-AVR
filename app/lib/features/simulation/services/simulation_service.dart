/// Engine-facing run controls (PRD §35). UI talks to the manager, not this.
abstract class SimulationService {
  Future<void> run();
  Future<void> pause();
  Future<void> stop();
  Future<void> step();
}
