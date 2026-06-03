import 'package:get/get.dart';

import '../controllers/producer_profile_controller.dart';

/// Binds the Producer Profile screen. The producer id arrives as the route
/// argument (`Get.toNamed(AppRoutes.producer, arguments: producerId)`); the use
/// cases and [SessionController] are already registered globally.
class ProducerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProducerProfileController>(
      () => ProducerProfileController(
        Get.find(),
        Get.find(),
        Get.find(),
        producerId: Get.arguments as String,
      ),
    );
  }
}
