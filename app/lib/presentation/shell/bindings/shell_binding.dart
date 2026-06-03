import 'package:get/get.dart';

import '../../club/controllers/club_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/shell_controller.dart';

/// Wires the shell and its four tab view-models.
///
/// Tab controllers are `lazyPut` so they are only instantiated when a tab is
/// first built, while the shell controller itself is needed immediately to
/// drive the navigation bar.
class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShellController>(ShellController());
    Get.lazyPut<HomeController>(HomeController.new);
    Get.lazyPut<SearchTabController>(SearchTabController.new);
    Get.lazyPut<ClubController>(ClubController.new);
    Get.lazyPut<ProfileController>(ProfileController.new);
  }
}
