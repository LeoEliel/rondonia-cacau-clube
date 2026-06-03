import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The app's brand block — a rounded cocoa-dark square with the cacao mark,
/// as seen on the onboarding and auth screens. Size is configurable so it can
/// act as a small wordmark glyph or a large hero badge.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.choco800, AppColors.choco950],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.spa_rounded,
        size: size * 0.5,
        color: AppColors.amberSoft,
      ),
    );
  }
}

/// Horizontal wordmark: the [BrandMark] glyph next to the "Cacau Clube /
/// RONDÔNIA" lockup, used in the onboarding header.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandMark(size: 34),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cacau Clube', style: theme.textTheme.titleMedium),
            Text(
              'RONDÔNIA',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
      ],
    );
  }
}
