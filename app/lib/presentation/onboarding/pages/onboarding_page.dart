import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/brand_mark.dart';
import '../controllers/onboarding_controller.dart';

/// First-run welcome carousel (design 01). The hero rotates cocoa cover photos
/// (cropped to fill, auto-advancing) under a soft brand veil with the cacao
/// mark; the headline carousel and dots stay in sync. Routes into sign-up
/// ("Começar") or sign-in ("Já tenho conta").
class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pad,
            AppSpacing.lg,
            AppSpacing.pad,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: BrandWordmark(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(child: _hero()),
              const SizedBox(height: AppSpacing.xl),
              Center(child: _tag(theme)),
              const SizedBox(height: AppSpacing.lg),
              _dots(theme),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: OnboardingController.slides.length,
                  itemBuilder: (_, i) {
                    final slide = OnboardingController.slides[i];
                    return _slide(theme, slide);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.signup),
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: const Text(AppStrings.onboardingStart),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => Get.toNamed(AppRoutes.login),
                child: const Text(AppStrings.onboardingHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Rotating cover photo for the current slide, cross-fading on advance, with
  /// the soft brand gradient veil and the cacao mark overlapping it.
  Widget _hero() {
    return Obx(() {
      final index = controller.page.value;
      final slide = OnboardingController.slides[index];
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: _heroCard(slide, key: ValueKey(index)),
      );
    });
  }

  Widget _heroCard(OnboardingSlide slide, {required Key key}) {
    return ClipRRect(
      key: key,
      borderRadius: AppRadii.brXl,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            slide.coverUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : _heroFallback(),
            errorBuilder: (context, error, stack) => _heroFallback(),
          ),
          // Soft brand veil over the photo (the same cocoa "degradê").
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.greenTint.withValues(alpha: 0.30),
                  AppColors.surface3.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
          const Center(child: BrandMark(size: 92)),
        ],
      ),
    );
  }

  /// Cocoa-toned placeholder while a cover loads or if it fails.
  Widget _heroFallback() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.greenTint, AppColors.surface3],
        ),
      ),
    );
  }

  Widget _tag(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.brPill,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        AppStrings.onboardingTag,
        style: theme.textTheme.labelMedium,
      ),
    );
  }

  Widget _dots(ThemeData theme) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < OnboardingController.slides.length; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: controller.page.value == i ? 22 : 6,
              decoration: BoxDecoration(
                color: controller.page.value == i
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                borderRadius: AppRadii.brPill,
              ),
            ),
        ],
      ),
    );
  }

  Widget _slide(ThemeData theme, OnboardingSlide slide) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          slide.body,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
