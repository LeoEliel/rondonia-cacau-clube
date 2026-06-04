import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Top header: greeting + location on the left, notifications + avatar on the
/// right. The greeting and avatar reflect the signed-in user from
/// [SessionController] and update reactively on sign-in / sign-out. When no one
/// is signed in it falls back to a neutral guest greeting and icon.
class HomeAppHeader extends StatelessWidget {
  const HomeAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final session = Get.find<SessionController>();

    return Obx(() {
      final user = session.user;
      final fullName = user?.name.trim() ?? '';
      final firstName = fullName.isEmpty ? null : fullName.split(' ').first;
      final greeting = firstName != null ? 'Olá, $firstName 🌱' : 'Olá! 🌱';

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppTypography.body(scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColors.amber, size: 22),
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
          _Avatar(name: firstName, photoUrl: user?.photoUrl),
        ],
      );
    });
  }
}

/// Circular user avatar: network photo when available, otherwise the first
/// initial of the name, otherwise a neutral guest icon. Loading / error states
/// fall back to the same initial/icon so the header never shows a broken image.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.photoUrl});

  final String? name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.greenSoft,
        shape: BoxShape.circle,
      ),
      child: (name == null || name!.isEmpty)
          ? const Icon(Icons.person_outline,
              color: AppColors.choco900, size: 26)
          : Text(
              name!.characters.first.toUpperCase(),
              style: AppTypography.section(AppColors.choco900),
            ),
    );

    final url = photoUrl;
    if (url == null || url.isEmpty) return fallback;

    return ClipOval(
      child: Image.network(
        url,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
        errorBuilder: (context, error, stack) => fallback,
      ),
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
