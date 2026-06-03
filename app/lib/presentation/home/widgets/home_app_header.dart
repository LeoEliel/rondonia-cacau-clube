import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Top header: greeting + location on the left, notifications + avatar on the
/// right. Greeting/avatar are static mock values for now (auth lands later).
class HomeAppHeader extends StatelessWidget {
  const HomeAppHeader({super.key, this.userName = 'Ana'});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $userName 🌱',
                style: AppTypography.body(scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.amber, size: 22),
                  const SizedBox(width: 6),
                  Text('Rondônia', style: theme.textTheme.headlineMedium),
                ],
              ),
            ],
          ),
        ),
        _CircleButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.greenSoft,
            shape: BoxShape.circle,
          ),
          child: Text(
            userName.characters.first.toUpperCase(),
            style: AppTypography.section(AppColors.choco900),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      shape: CircleBorder(side: BorderSide(color: scheme.outlineVariant)),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: scheme.onSurface, size: 24),
        ),
      ),
    );
  }
}
