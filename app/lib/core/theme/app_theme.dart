import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Central place that assembles the warm-cocoa Material 3 themes
/// (light + dark) from the design tokens.
abstract final class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // Light
  // ---------------------------------------------------------------------------
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.mel,
    onPrimary: Colors.white,
    primaryContainer: AppColors.amberSoft,
    onPrimaryContainer: AppColors.choco900,
    secondary: AppColors.verde,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.verdeSoft,
    onSecondaryContainer: AppColors.choco900,
    tertiary: AppColors.caramel,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.surface3,
    onTertiaryContainer: AppColors.choco900,
    error: AppColors.error,
    onError: AppColors.onError,
    surface: AppColors.surface,
    onSurface: AppColors.texto,
    surfaceDim: AppColors.surface3,
    surfaceBright: AppColors.surface,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: AppColors.surface2,
    surfaceContainer: AppColors.surface2,
    surfaceContainerHigh: AppColors.surface3,
    surfaceContainerHighest: AppColors.surface3,
    onSurfaceVariant: AppColors.texto2,
    outline: AppColors.texto3,
    outlineVariant: AppColors.linha,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.choco900,
    onInverseSurface: AppColors.screen,
    inversePrimary: AppColors.amberSoft,
    surfaceTint: AppColors.mel,
  );

  // ---------------------------------------------------------------------------
  // Dark
  // ---------------------------------------------------------------------------
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.amberSoft,
    onPrimary: AppColors.choco900,
    primaryContainer: AppColors.caramel,
    onPrimaryContainer: AppColors.screen,
    secondary: AppColors.verdeSoft,
    onSecondary: AppColors.choco900,
    secondaryContainer: AppColors.verde,
    onSecondaryContainer: AppColors.screen,
    tertiary: AppColors.caramel,
    onTertiary: AppColors.screen,
    tertiaryContainer: AppColors.choco600,
    onTertiaryContainer: AppColors.screen,
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    surface: AppColors.choco900,
    onSurface: AppColors.screen,
    surfaceDim: AppColors.choco900,
    surfaceBright: AppColors.choco600,
    surfaceContainerLowest: Color(0xFF241410),
    surfaceContainerLow: Color(0xFF34211A),
    surfaceContainer: AppColors.choco700,
    surfaceContainerHigh: AppColors.choco600,
    surfaceContainerHighest: Color(0xFF7A4A2C),
    onSurfaceVariant: AppColors.texto3,
    outline: AppColors.texto2,
    outlineVariant: AppColors.choco700,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.screen,
    onInverseSurface: AppColors.choco900,
    inversePrimary: AppColors.mel,
    surfaceTint: AppColors.amberSoft,
  );

  static ThemeData get light => _build(_lightScheme, AppColors.screen);
  static ThemeData get dark => _build(_darkScheme, AppColors.choco900);

  static ThemeData _build(ColorScheme scheme, Color scaffoldBackground) {
    final textTheme = AppTypography.textTheme(
      primary: scheme.onSurface,
      secondary: scheme.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: AppTypography.section(scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brLg),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: AppTypography.bodyBold(scheme.onPrimary),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          textStyle: AppTypography.bodyBold(scheme.onPrimary),
          minimumSize: const Size(0, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: AppTypography.bodyBold(scheme.onSurface),
          minimumSize: const Size(0, 52),
          side: BorderSide(color: scheme.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: AppTypography.bodyBold(scheme.primary),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: AppTypography.auxiliary(scheme.onSurface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: AppTypography.body(scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.brPill,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.brPill,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.brPill,
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTypography.overline(
            selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: AppTypography.body(scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
      ),
    );
  }
}
