import 'package:get/get.dart';

import '../controllers/producer_profile_controller.dart';

/// Binds the Producer Profile screen. The producer id arrives as a route URL
/// parameter (`/producer?id=…`) with the in-memory `arguments` as a fast path.
/// Reading `parameters` first keeps the screen working across a web refresh /
/// back navigation (which drop `arguments`); a missing id degrades to a
/// "not found" state rather than throwing. Use cases and [SessionController]
/// are registered globally.
class ProducerProfileBinding extends Bindings {
  @override
  void dependencies() {
    final id = Get.parameters['id'] ?? (Get.arguments as String?) ?? '';
    Get.lazyPut<ProducerProfileController>(
      () => ProducerProfileController(
        Get.find(),
        Get.find(),
        Get.find(),
        producerId: id,
      ),
    );
  }
}
