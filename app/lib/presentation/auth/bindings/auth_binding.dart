import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

/// Binds the shared [AuthController] used by both the login and sign-up routes.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
  }
}
