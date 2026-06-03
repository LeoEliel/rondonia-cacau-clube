import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../controllers/club_controller.dart';
import '../widgets/benefit_row.dart';
import '../widgets/club_content_card.dart';

/// Cocoa Club tab (design 07): the free vs. paid tier comparison, a mock
/// "Assinar o Clube" CTA and a teaser of members-only content. Membership state
/// is read from the session, so subscribing here updates the Profile tab too.
class ClubPage extends GetView<ClubController> {
  const ClubPage({super.key});

  // Cream tones used for text/checks on the dark "Clube" card.
  static const Color _cream = AppColors.amberTint;
  static const Color _creamMuted = Color(0xFFD9C9AC);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pad,
            AppSpacing.sect,
            AppSpacing.pad,
            AppSpacing.sect,
          ),
          children: [
            _header(theme),
            const SizedBox(height: AppSpacing.sect),
            Obx(() => _freeCard(theme)),
            const SizedBox(height: AppSpacing.gap),
            Obx(() => _paidCard(context, theme)),
            const SizedBox(height: AppSpacing.sect),
            Text(AppStrings.clubContentSection, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.gap),
            ...controller.exclusiveContent.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.gap),
                child: ClubContentCard(content: c),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.amberTint,
            borderRadius: AppRadii.brMd,
          ),
          child: const Icon(Icons.workspace_premium,
              color: AppColors.amberDeep, size: 32),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.clubHeadline,
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.clubSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _freeCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.brLg,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(AppStrings.clubFreeTier,
                    style: theme.textTheme.titleLarge),
              ),
              if (!controller.isMember)
                Text(
                  AppStrings.clubCurrentPlan,
                  style: AppTypography.overline(AppColors.amberDeep),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          BenefitRow(
            label: AppStrings.clubFreeBenefit1,
            checkColor: AppColors.amber,
            textStyle: theme.textTheme.bodyMedium!,
          ),
          BenefitRow(
            label: AppStrings.clubFreeBenefit2,
            checkColor: AppColors.amber,
            textStyle: theme.textTheme.bodyMedium!,
          ),
          BenefitRow(
            label: AppStrings.clubFreeBenefit3,
            checkColor: AppColors.amber,
            textStyle: theme.textTheme.bodyMedium!,
          ),
        ],
      ),
    );
  }

  Widget _paidCard(BuildContext context, ThemeData theme) {
    final benefitStyle = AppTypography.body(_cream);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.choco950,
        borderRadius: AppRadii.brLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.clubPaidTier,
                  style: AppTypography.section(_cream),
                ),
              ),
              _paidBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.clubPaidIntro,
            style: AppTypography.bodyBold(AppColors.amberSoft),
          ),
          const SizedBox(height: AppSpacing.sm),
          BenefitRow(
            label: AppStrings.clubPaidBenefit1,
            checkColor: AppColors.amberSoft,
            textStyle: benefitStyle,
          ),
          BenefitRow(
            label: AppStrings.clubPaidBenefit2,
            checkColor: AppColors.amberSoft,
            textStyle: benefitStyle,
          ),
          BenefitRow(
            label: AppStrings.clubPaidBenefit3,
            checkColor: AppColors.amberSoft,
            textStyle: benefitStyle,
          ),
          BenefitRow(
            label: AppStrings.clubPaidBenefit4,
            checkColor: AppColors.amberSoft,
            textStyle: benefitStyle,
          ),
          const SizedBox(height: AppSpacing.lg),
          _cta(context, theme),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              AppStrings.clubNoCharge,
              style: AppTypography.meta(_creamMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paidBadge() {
    final isMember = controller.isMember;
    final label =
        isMember ? AppStrings.clubCurrentPlan : AppStrings.clubRecommended;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.amber,
        borderRadius: AppRadii.brPill,
      ),
      child: Text(label, style: AppTypography.overline(AppColors.choco950)),
    );
  }

  Future<void> _onSubscribe(BuildContext context) async {
    final subscribed = await controller.subscribe();
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    if (subscribed) {
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.choco900,
          content: Text(
            '${AppStrings.clubSubscribedTitle} ${AppStrings.clubSubscribedBody}',
          ),
        ),
      );
    } else if (controller.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(controller.errorMessage!),
        ),
      );
    }
  }

  Widget _cta(BuildContext context, ThemeData theme) {
    if (controller.isMember) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: null,
          style: FilledButton.styleFrom(
            disabledBackgroundColor: AppColors.choco800,
            disabledForegroundColor: _cream,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          ),
          icon: const Icon(Icons.check_circle, size: 20),
          label: const Text(AppStrings.clubAlreadyMember),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: controller.isSubscribing ? null : () => _onSubscribe(context),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: AppColors.choco950,
          disabledBackgroundColor: AppColors.amber.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        ),
        child: controller.isSubscribing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(AppColors.choco950),
                ),
              )
            : Text(
                AppStrings.clubSubscribe,
                style: AppTypography.bodyBold(AppColors.choco950),
              ),
      ),
    );
  }
}
