import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

/// Binds the shared [AuthController] used by both the login and sign-up routes.
///
/// The two routes toggle between each other with [Get.offNamed], which replaces
/// (and disposes) the leaving route. Since both pages share one controller that
/// owns the form's [TextEditingController]s, a plain route-scoped registration
/// gets disposed out from under the page being shown. Registering it as
/// `permanent` keeps the single instance alive across the swap; the controller
/// clears its own fields once sign-in completes so re-entry starts clean.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<AuthController>()) return;
    Get.put<AuthController>(
      AuthController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
      permanent: true,
    );
  }
}
