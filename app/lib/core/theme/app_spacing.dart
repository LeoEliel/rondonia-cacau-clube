/// Spacing tokens from `design_tokens.md`.
///
/// [base scale] (multiples of 4) is the underlying ruler; the *semantic* tokens
/// (`pad`, `gap`, `sect`, `cardPad`, …) are the values the design actually
/// reaches for and are what screens should use most of the time.
abstract final class AppSpacing {
  AppSpacing._();

  // Base scale: 4 · 8 · 12 · 16 · 20 · 26
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 26;

  // Semantic tokens (default density, multiplier --d = 1.0)
  static const double pad = 20; // screen side padding
  static const double gap = 14; // gap between cards / blocks
  static const double gapSm = 9; // gap between chips / compact items
  static const double sect = 26; // space between sections
  static const double cardPad = 15; // inner card padding
}
