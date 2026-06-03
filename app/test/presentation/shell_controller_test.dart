import 'package:app/presentation/shell/controllers/shell_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShellController', () {
    late ShellController controller;

    setUp(() => controller = ShellController());

    test('starts on the first tab', () {
      expect(controller.currentIndex, 0);
    });

    test('changeTab updates the selected index', () {
      controller.changeTab(2);
      expect(controller.currentIndex, 2);
    });

    test('changeTab to the current index is a no-op', () {
      controller.changeTab(0);
      expect(controller.currentIndex, 0);
    });
  });
}
