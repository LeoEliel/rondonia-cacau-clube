import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Amber star + numeric aggregate rating (e.g. ★ 4.9). Shown on product and
/// producer cards.
class RatingLabel extends StatelessWidget {
  const RatingLabel(this.rating, {super.key, this.size = 18});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size + 2, color: AppColors.amber),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1), style: AppTypography.bodyBold(color)),
      ],
    );
  }
}
