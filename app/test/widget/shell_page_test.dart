import 'package:app/core/controllers/theme_controller.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/presentation/club/controllers/club_controller.dart';
import 'package:app/presentation/home/controllers/home_controller.dart';
import 'package:app/presentation/profile/controllers/profile_controller.dart';
import 'package:app/presentation/search/controllers/search_controller.dart';
import 'package:app/presentation/shell/controllers/shell_controller.dart';
import 'package:app/presentation/shell/pages/shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    Get.testMode = true;
    Get.put<SharedPreferences>(prefs, permanent: true);
    Get.put<ThemeController>(ThemeController(prefs), permanent: true);
    Get.put<ShellController>(ShellController());
    Get.put<HomeController>(HomeController());
    Get.put<SearchTabController>(SearchTabController());
    Get.put<ClubController>(ClubController());
    Get.put<ProfileController>(ProfileController());
  });

  tearDown(Get.reset);

  Widget wrap() => GetMaterialApp(
        theme: AppTheme.light,
        home: const ShellPage(),
      );

  testWidgets('renders the four navigation destinations', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Início'), findsWidgets);
    expect(find.text('Buscar'), findsWidgets);
    expect(find.text('Clube'), findsWidgets);
    expect(find.text('Perfil'), findsWidgets);
  });

  testWidgets('tapping a destination changes the active tab', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(Get.find<ShellController>().currentIndex, 0);

    await tester.tap(find.text('Clube'));
    await tester.pumpAndSettle();

    expect(Get.find<ShellController>().currentIndex, 2);
  });
}
