import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../shell/controllers/shell_controller.dart';

/// Top header: greeting + welcome on the left, notifications + avatar on the
/// right. The greeting and avatar reflect the signed-in user from
/// [SessionController] and update reactively on sign-in / sign-out. When no one
/// is signed in it falls back to a neutral guest greeting and icon. Tapping the
/// avatar opens the Perfil tab; the bell is a placeholder until notifications
/// are built.
class HomeAppHeader extends StatelessWidget {
  const HomeAppHeader({super.key});

  /// Perfil is the fourth bottom-nav tab (Início · Buscar · Clube · Perfil).
  static const int _profileTabIndex = 3;

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
                // Static welcome with the pin — replaces the previously
                // hardcoded "Rondônia" location label (the app isn't
                // location-aware yet, so this reads as a club welcome).
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.amber,
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        AppStrings.homeWelcome,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _CircleButton(
            icon: Icons.notifications_none_rounded,
            onTap: () => _showNotificationsSoon(context),
          ),
          const SizedBox(width: AppSpacing.md),
          _Avatar(
            name: firstName,
            photoUrl: user?.photoUrl,
            onTap: _openProfile,
          ),
        ],
      );
    });
  }

  /// Notifications aren't built yet — acknowledge the tap with a hint instead of
  /// a dead no-op (mirrors the Product Detail "em breve" affordances).
  void _showNotificationsSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(AppStrings.notificationsComingSoon)),
      );
  }

  /// Switches the shell to the Perfil tab.
  void _openProfile() {
    if (Get.isRegistered<ShellController>()) {
      Get.find<ShellController>().changeTab(_profileTabIndex);
    }
  }
}

/// Circular user avatar: network photo when available, otherwise the first
/// initial of the name, otherwise a neutral guest icon. Loading / error states
/// fall back to the same initial/icon so the header never shows a broken image.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.photoUrl, this.onTap});

  final String? name;
  final String? photoUrl;
  final VoidCallback? onTap;

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
          ? const Icon(
              Icons.person_outline,
              color: AppColors.choco900,
              size: 26,
            )
          : Text(
              name!.characters.first.toUpperCase(),
              style: AppTypography.section(AppColors.choco900),
            ),
    );

    final url = photoUrl;
    final Widget avatar = (url == null || url.isEmpty)
        ? fallback
        : ClipOval(
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

    if (onTap == null) return avatar;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: avatar,
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
