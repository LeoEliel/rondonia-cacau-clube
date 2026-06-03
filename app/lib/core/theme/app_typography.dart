import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale from `design_tokens.md` §2.
///
/// Two families:
/// - **Lora** (serif) for display / titles / section headers / product names /
///   italic story text.
/// - **Hanken Grotesk** (sans) for body, auxiliary/meta, overlines and seals.
///
/// [textTheme] maps these tokens onto Material 3 [TextTheme] slots so widgets
/// rely on `Theme.of(context).textTheme.*` and stay on-brand. Roles without a
/// natural Material slot (story, seal) are exposed as direct helpers.
abstract final class AppTypography {
  AppTypography._();

  /// Display — Lora 34 / 600 / 1.12
  static TextStyle display(Color color) => GoogleFonts.lora(
        fontSize: 34,
        height: 1.12,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: color,
      );

  /// Screen title (H1) — Lora 26 / 600 / 1.12
  static TextStyle title(Color color) => GoogleFonts.lora(
        fontSize: 26,
        height: 1.12,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  /// Section title — Lora 19 / 600 / 1.2
  static TextStyle section(Color color) => GoogleFonts.lora(
        fontSize: 19,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// Product name — Lora 15.5 / 600 / 1.2
  static TextStyle productName(Color color) => GoogleFonts.lora(
        fontSize: 15.5,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// Story (italic) — Lora italic 15.5 / 400 / 1.55
  static TextStyle story(Color color) => GoogleFonts.lora(
        fontSize: 15.5,
        height: 1.55,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: color,
      );

  /// Body — Hanken Grotesk 15 / 400 / 1.5
  static TextStyle body(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color,
      );

  /// Body strong — Hanken Grotesk 15 / 700 / 1.45
  static TextStyle bodyBold(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 15,
        height: 1.45,
        fontWeight: FontWeight.w700,
        color: color,
      );

  /// Auxiliary / meta — Hanken Grotesk 12.5 / 600 / 1.4
  static TextStyle meta(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 12.5,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: color,
      );

  /// Overline / label — Hanken Grotesk 10.5 / 700 / uppercase / +0.5
  static TextStyle overline(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 10.5,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: color,
      );

  /// Seal — Hanken Grotesk 10.5 / 700 / +0.2
  static TextStyle seal(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 10.5,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color,
      );

  /// Builds a Material 3 [TextTheme] from the tokens for the given text colors.
  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
  }) {
    return TextTheme(
      displayLarge: display(primary),
      displayMedium: display(primary),
      displaySmall: title(primary),
      headlineLarge: title(primary),
      headlineMedium: title(primary),
      headlineSmall: section(primary),
      titleLarge: section(primary),
      titleMedium: productName(primary),
      titleSmall: meta(secondary),
      bodyLarge: body(primary),
      bodyMedium: body(primary),
      bodySmall: meta(secondary),
      labelLarge: bodyBold(primary),
      labelMedium: meta(secondary),
      labelSmall: overline(secondary),
    );
  }
}
