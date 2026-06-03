import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

/// Binds the onboarding carousel controller.
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(OnboardingController.new);
  }
}
