/// Shared canvas/grid constants (PRD §31).
abstract final class AppConstants {
  /// Snap step and symbol unit. 32px keeps symbols, pins and touch targets
  /// comfortably tappable on phones; decorative dot pitch is separate.
  static const gridStep = 32.0;
  static const minScale = 0.2;
  static const maxScale = 4.0;
  static const historyLimit = 50;
}
