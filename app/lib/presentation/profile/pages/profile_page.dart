import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/profile_controller.dart';

/// Profile tab: identity, Club membership status, follow count, appearance and
/// sign-out. Composed from the design tokens (no dedicated screen mock).
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pad),
        children: [
          _header(theme),
          const SizedBox(height: AppSpacing.sect),
          _membershipCard(context, theme),
          const SizedBox(height: AppSpacing.gap),
          _followingTile(theme),
          const SizedBox(height: AppSpacing.gap),
          _appearanceCard(theme),
          const SizedBox(height: AppSpacing.sect),
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.4)),
            ),
            icon: const Icon(Icons.logout, size: 20),
            label: const Text(AppStrings.profileSignOut),
          ),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme) {
    final photo = controller.photoUrl;
    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: AppColors.amberTint,
          backgroundImage: (photo != null && photo.isNotEmpty)
              ? NetworkImage(photo)
              : null,
          child: (photo == null || photo.isEmpty)
              ? Text(controller.initials,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(color: AppColors.choco800))
              : null,
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 2),
              Text(
                controller.email,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _membershipCard(BuildContext context, ThemeData theme) {
    if (controller.isClubMember) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.amberTint,
          borderRadius: AppRadii.brMd,
          border: Border.all(color: AppColors.amberSoft),
        ),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.amberDeep),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.profileMember,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: AppColors.choco900)),
                  Text(
                    'Conteúdo exclusivo da floresta liberado.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.choco700),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.brMd,
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_outlined,
              color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.profileFreePlan,
                    style: theme.textTheme.titleMedium),
                Text(
                  'Assine para histórias e lançamentos exclusivos.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: () => Get.find<ShellController>().changeTab(2),
            child: const Text(AppStrings.profileSeeClub),
          ),
        ],
      ),
    );
  }

  Widget _followingTile(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.brMd,
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite_border, color: AppColors.green),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(AppStrings.profileFollowing,
                style: theme.textTheme.bodyLarge),
          ),
          Obx(
            () => Text(
              '${controller.followingCount}',
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _appearanceCard(ThemeData theme) {
    return Material(
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.brMd,
        side: BorderSide(color: AppColors.line),
      ),
      child: Obx(
        () => SwitchListTile(
          value: controller.isDark,
          onChanged: controller.setDarkMode,
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text(AppStrings.profileDarkMode),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.profileSignOut),
        content: const Text(AppStrings.profileSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.profileSignOut),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.signOut();
  }
}
