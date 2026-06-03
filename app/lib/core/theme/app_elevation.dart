import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Elevation tokens from `design_tokens.md` — cocoa-tinted soft shadows
/// (`rgba(46,28,18,…)` == [AppColors.choco900]).
///
/// Exposed as ready-to-use `boxShadow` lists since the design relies on custom
/// shadows rather than Material's default elevation overlays.
abstract final class AppElevation {
  AppElevation._();

  static List<BoxShadow> get e1 => [
        BoxShadow(
          color: AppColors.choco900.withValues(alpha: 0.06),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: AppColors.choco900.withValues(alpha: 0.05),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get e2 => [
        BoxShadow(
          color: AppColors.choco900.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.choco900.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get e3 => [
        BoxShadow(
          color: AppColors.choco900.withValues(alpha: 0.14),
          blurRadius: 34,
          offset: const Offset(0, 14),
        ),
        BoxShadow(
          color: AppColors.choco900.withValues(alpha: 0.07),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
}
