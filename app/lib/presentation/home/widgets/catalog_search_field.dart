import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Read-only search entry point. Tapping it (or the filter icon) opens the
/// Search tab — the catalog's own filtering is done via the category chips.
class CatalogSearchField extends StatelessWidget {
  const CatalogSearchField({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadii.brPill,
          boxShadow: AppElevation.e1,
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Buscar mel, nibs, produtores…',
                style: AppTypography.body(scheme.onSurfaceVariant),
              ),
            ),
            Icon(Icons.tune_rounded, color: AppColors.amber),
          ],
        ),
      ),
    );
  }
}
