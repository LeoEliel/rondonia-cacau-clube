import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';

/// One onboarding slide: a cover photo + headline + supporting line.
class OnboardingSlide {
  const OnboardingSlide(this.title, this.body, this.coverUrl);
  final String title;
  final String body;

  /// Cover photo shown in the carousel hero for this slide.
  final String coverUrl;
}

/// Drives the onboarding carousel: owns the [PageController] and the current
/// page index so the cover photo, headline and dot indicator stay in sync with
/// swipes.
class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt page = 0.obs;

  /// Rotates the carousel automatically; users can still swipe manually.
  Timer? _autoAdvance;
  static const Duration _interval = Duration(seconds: 5);

  /// Cocoa-themed cover photo (Pexels, keyless) for the hero carousel.
  static String _cover(int id) =>
      'https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg'
      '?auto=compress&cs=tinysrgb&w=1000';

  // Covers track the slide copy: cacao pod → mel de cacau jar → chocolate.
  static final List<OnboardingSlide> slides = [
    OnboardingSlide(AppStrings.onboardingTitle1, AppStrings.onboardingBody1,
        _cover(14436364)),
    OnboardingSlide(AppStrings.onboardingTitle2, AppStrings.onboardingBody2,
        _cover(4921856)),
    OnboardingSlide(AppStrings.onboardingTitle3, AppStrings.onboardingBody3,
        _cover(6167328)),
  ];

  @override
  void onInit() {
    super.onInit();
    _autoAdvance = Timer.periodic(_interval, (_) => _advance());
  }

  void onPageChanged(int index) => page.value = index;

  /// Advances to the next slide (wrapping), animating the carousel.
  void _advance() {
    if (!pageController.hasClients) return;
    final next = (page.value + 1) % slides.length;
    pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    _autoAdvance?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
