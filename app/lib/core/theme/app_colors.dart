import 'package:flutter/material.dart';

/// Raw color tokens for the "Rondônia Cacau Clube" design system.
///
/// Mirrors `design_tokens.md` (repo root) 1:1 — that file is the source of
/// truth. Nothing in the app should hard-code hex values; reference these named
/// tokens (or, preferably, the [ColorScheme] derived from them) instead.
abstract final class AppColors {
  AppColors._();

  // --- Surfaces ---
  static const Color screenBg = Color(0xFFFBF4E9); // warm cream screen bg
  static const Color surface = Color(0xFFFFFFFF); // cards, sheets, fields
  static const Color surface2 = Color(0xFFFBF2E2); // subtle / alternating
  static const Color surface3 = Color(0xFFF4E8D4); // rails, bars, neutral chips

  // --- Cacau (browns) ---
  static const Color choco950 = Color(0xFF241208); // dark gradient / premium
  static const Color choco900 = Color(0xFF2E1C12); // titles, primary ink
  static const Color choco800 = Color(0xFF3A2317); // dark button, strong icons
  static const Color choco700 = Color(0xFF5A3522); // chip text, brandmark
  static const Color choco600 = Color(0xFF6B3F23); // support brown
  static const Color caramel = Color(0xFFB5703A); // "Comércio Justo", details

  // --- Mel / Amber (primary accent) ---
  static const Color amber = Color(0xFFD98B1F); // default accent: CTA, pin
  static const Color amberDeep = Color(0xFFC0741A); // text/icon on tint, links
  static const Color amberSoft = Color(0xFFF3C95E); // highlights, light stars
  static const Color amberTint = Color(0xFFFBEFD2); // "Cacau Fino" bg, hero card

  // --- Forest green (secondary accent) ---
  static const Color green = Color(0xFF3F7A43); // alt accent, WhatsApp
  static const Color greenDeep = Color(0xFF356637); // text on tint, eco seals
  static const Color greenSoft = Color(0xFF6BA45F); // WhatsApp border, accents
  static const Color greenTint = Color(0xFFE6F0DF); // "Orgânico" seal bg

  // --- Text & lines ---
  static const Color text = Color(0xFF2E1C12); // primary text
  static const Color text2 = Color(0xFF7A5D45); // secondary / descriptions
  static const Color text3 = Color(0xFFA98E72); // tertiary / placeholders
  static const Color line = Color(0xFFECDFC8); // borders, dividers
  static const Color line2 = Color(0xFFE0CFB1); // stronger borders, idle chips

  // --- Functional ---
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
}
