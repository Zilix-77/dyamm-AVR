/// Tiny JSON helpers for .dyamm project files (PRD §39).
double safeDouble(dynamic v, [double fallback = 0]) =>
    v is num ? v.toDouble() : fallback;
