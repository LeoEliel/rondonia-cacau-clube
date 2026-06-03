import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/theme_controller.dart';

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
  }
}
