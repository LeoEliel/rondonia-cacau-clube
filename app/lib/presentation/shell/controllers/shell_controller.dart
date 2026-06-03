import 'package:get/get.dart';

/// View-model for the app shell. Owns the selected bottom-navigation tab.
///
/// Single responsibility: track and mutate the active tab index. The page reads
/// [currentIndex] reactively via `Obx` and swaps tabs through an `IndexedStack`,
/// so tab state is preserved while switching.
class ShellController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changeTab(int index) {
    if (index == _currentIndex.value) return;
    _currentIndex.value = index;
  }
}
