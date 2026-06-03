import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/theme_controller.dart';
import '../session/session_controller.dart';
import 'data_binding.dart';

/// App-wide dependency graph wired before the first route opens.
///
/// Only cross-cutting singletons live here (theme, local storage). Feature
/// dependencies belong in their own route [Bindings] so each screen owns its
/// graph and nothing leaks across boundaries.
///
/// Expects [SharedPreferences] to already be registered in `main()` (it must
/// be resolved asynchronously before `runApp`).
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final prefs = Get.find<SharedPreferences>();
    Get.put<ThemeController>(ThemeController(prefs), permanent: true);

    // Compose the data graph (Firestore → data sources → repositories → use
    // cases) so feature bindings can resolve use cases on demand.
    DataBinding().dependencies();

    // Current-user state (follow + reviews identity). Permanent so the followed
    // set survives across route changes. Auth replaces the demo identity in M5.
    Get.put<SessionController>(
      SessionController(Get.find(), Get.find(), Get.find()),
      permanent: true,
    );
  }
}
