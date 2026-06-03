import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';

/// One onboarding slide: a headline + supporting line.
class OnboardingSlide {
  const OnboardingSlide(this.title, this.body);
  final String title;
  final String body;
}

/// Drives the onboarding carousel: owns the [PageController] and the current
/// page index so the dot indicator stays in sync with swipes.
class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt page = 0.obs;

  static const List<OnboardingSlide> slides = [
    OnboardingSlide(AppStrings.onboardingTitle1, AppStrings.onboardingBody1),
    OnboardingSlide(AppStrings.onboardingTitle2, AppStrings.onboardingBody2),
    OnboardingSlide(AppStrings.onboardingTitle3, AppStrings.onboardingBody3),
  ];

  void onPageChanged(int index) => page.value = index;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
