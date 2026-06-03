import 'package:flutter/material.dart';

/// Raw color tokens for the "Rondônia Cacau Clube" design system.
///
/// These are the single source of truth taken from the design tokens screen
/// (`design/screens/Tokens _ Componentes.png`). Nothing in the app should
/// hard-code hex values; reference these named tokens instead so the palette
/// stays consistent across light and dark themes.
abstract final class AppColors {
  AppColors._();

  // --- Surfaces ---
  static const Color screen = Color(0xFFFBF4E9); // app background (cream)
  static const Color surface = Color(0xFFFFFFFF); // cards / sheets
  static const Color surface2 = Color(0xFFFBF2E2); // subtle raised surface
  static const Color surface3 = Color(0xFFF4E8D4); // deeper raised surface

  // --- Cacau (cocoa browns + caramel) ---
  static const Color choco900 = Color(0xFF2E1C12); // deepest cocoa
  static const Color choco700 = Color(0xFF5A3522);
  static const Color choco600 = Color(0xFF6B3F23);
  static const Color caramel = Color(0xFFB5703A);

  // --- Highlight & accent ---
  static const Color mel = Color(0xFFD98B1F); // honey amber (primary accent)
  static const Color amberSoft = Color(0xFFF3C95E);
  static const Color verde = Color(0xFF3F7A43); // forest green accent
  static const Color verdeSoft = Color(0xFF6BA45F);

  // --- Text & lines ---
  static const Color texto = Color(0xFF2E1C12); // primary text
  static const Color texto2 = Color(0xFF7A5D45); // secondary text
  static const Color texto3 = Color(0xFFA98E72); // tertiary / hints
  static const Color linha = Color(0xFFECDFC8); // hairline dividers

  // --- Functional ---
  static const Color whatsapp = Color(0xFF25D366);
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
}
