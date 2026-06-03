import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale from the design tokens.
///
/// Two families:
/// - **Lora** (serif) for display / titles / section headers.
/// - **Hanken Grotesk** (sans) for body, auxiliary text and overlines.
///
/// [textTheme] maps these tokens onto Material 3 [TextTheme] slots so widgets
/// can rely on `Theme.of(context).textTheme.*` and stay on-brand.
abstract final class AppTypography {
  AppTypography._();

  static TextStyle display(Color color) => GoogleFonts.lora(
        fontSize: 34,
        height: 1.12,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle title(Color color) => GoogleFonts.lora(
        fontSize: 24,
        height: 1.18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle section(Color color) => GoogleFonts.lora(
        fontSize: 19,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle body(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 15,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodyBold(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 15,
        height: 1.4,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle auxiliary(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 12.5,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle overline(Color color) => GoogleFonts.hankenGrotesk(
        fontSize: 10.5,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
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
      titleMedium: bodyBold(primary),
      titleSmall: auxiliary(primary),
      bodyLarge: body(primary),
      bodyMedium: body(primary),
      bodySmall: auxiliary(secondary),
      labelLarge: bodyBold(primary),
      labelMedium: auxiliary(secondary),
      labelSmall: overline(secondary),
    );
  }
}
