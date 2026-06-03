import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import '../theme/app_radii.dart';
import '../theme/app_seals.dart';
import '../theme/app_typography.dart';

/// Pill badge for a [QualitySeal] (icon + label) using the design's seal color
/// map. Reused on product cards, the hero banner and producer profiles.
class SealBadge extends StatelessWidget {
  const SealBadge(this.seal, {super.key});

  final QualitySeal seal;

  @override
  Widget build(BuildContext context) {
    final style = kSealStyles[seal]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: AppRadii.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 14, color: style.foreground),
          const SizedBox(width: 5),
          Text(style.label, style: AppTypography.seal(style.foreground)),
        ],
      ),
    );
  }
}
