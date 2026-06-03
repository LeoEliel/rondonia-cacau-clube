import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/seal_badge.dart';
import '../../../domain/entities/enums.dart';

/// The "Em destaque" hero banner: cocoa-gradient card with editorial copy and
/// chips for the featured product's top seal + origin municipality.
class HeroFeaturedCard extends StatelessWidget {
  const HeroFeaturedCard({
    super.key,
    required this.kicker,
    required this.title,
    this.seal,
    this.municipality,
    this.onTap,
  });

  final String kicker;
  final String title;
  final QualitySeal? seal;
  final String? municipality;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: const BoxDecoration(
          borderRadius: AppRadii.brXl,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.choco600, AppColors.choco950],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kicker.toUpperCase(),
              style: AppTypography.overline(AppColors.amberSoft),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTypography.display(Colors.white),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (seal != null) SealBadge(seal!),
                if (municipality != null && municipality!.isNotEmpty)
                  _LocationPill(municipality!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill(this.municipality);

  final String municipality;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.place_outlined, size: 14, color: AppColors.choco700),
          const SizedBox(width: 5),
          Text(municipality, style: AppTypography.seal(AppColors.choco700)),
        ],
      ),
    );
  }
}
