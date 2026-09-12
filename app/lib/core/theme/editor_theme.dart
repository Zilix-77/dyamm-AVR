import 'package:flutter/material.dart';

/// Dark mono CAD tokens — exact values from the Stitch export (`code.html`).
/// Single source of truth for every editor surface; no per-widget hex.
abstract final class EditorColors {
  static const canvas = Color(0xFF040404);
  static const panel = Color(0xFF0D0D0D);
  static const card = Color(0xFF161616);
  static const border = Color(0xFF282828);
  static const borderLight = Color(0xFF383838);
  static const active = Color(0xFF242424);
  static const muted = Color(0xFF7E7E7E);
  static const bright = Color(0xFFF4F4F4);
  static const pill = Color(0xFF121212);
  static const sheet = Color(0xFF101010);
  static const pad = Color(0xFF080808);
  static const headerStrip = Color(0xFF0A0A0A);
  static const chipStrip = Color(0xFF0C0C0C);

  /// System-only monospace stack (Google Fonts deferred — zero new deps).
  static const fontMono = 'monospace';
}

/// Dark editor ThemeData, applied app-wide — including the Project Manager,
// which shares the same CAD visual language (portrait file-manager layout).
ThemeData editorTheme() {
  const scheme = ColorScheme.dark(
    primary: EditorColors.bright,
    onPrimary: Colors.black,
    surface: EditorColors.panel,
    onSurface: EditorColors.bright,
    surfaceContainerHighest: EditorColors.card,
    outline: EditorColors.border,
    outlineVariant: EditorColors.borderLight,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: EditorColors.canvas,
    visualDensity: VisualDensity.compact,
    appBarTheme: const AppBarTheme(
      backgroundColor: EditorColors.panel,
      foregroundColor: EditorColors.bright,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: EditorColors.panel),
    cardTheme: CardThemeData(
      color: EditorColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: EditorColors.border),
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: EditorColors.card,
      selectedColor: EditorColors.bright,
      side: BorderSide(color: EditorColors.border),
      labelStyle: TextStyle(color: EditorColors.bright, fontSize: 11),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: EditorColors.card,
      hintStyle: const TextStyle(color: EditorColors.muted, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: EditorColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: EditorColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: EditorColors.bright),
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      collapsedTextColor: EditorColors.muted,
      textColor: EditorColors.bright,
      iconColor: EditorColors.muted,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: EditorColors.card,
      contentTextStyle: TextStyle(color: EditorColors.bright),
    ),
  );
}
