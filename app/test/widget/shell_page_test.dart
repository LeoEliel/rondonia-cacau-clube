import 'package:app/core/controllers/theme_controller.dart';
import 'package:app/core/session/session_controller.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_producers.dart';
import 'package:app/domain/usecases/get_products.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
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

import '../helpers/fake_repositories.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    Get.testMode = true;
    Get.put<SharedPreferences>(prefs, permanent: true);
    final themeController = ThemeController(prefs);
    Get.put<ThemeController>(themeController, permanent: true);
    final authRepo = FakeAuthRepository();
    final userRepo = FakeUserRepository();
    final session = SessionController(
      GetCurrentUser(authRepo),
      GetUser(userRepo),
      SignOut(authRepo),
      FollowProducer(userRepo),
      UnfollowProducer(userRepo),
    );
    Get.put<SessionController>(session, permanent: true);
    Get.put<ShellController>(ShellController());
    Get.put<HomeController>(HomeController(
      GetProducts(FakeProductRepository()),
      GetProducers(FakeProducerRepository()),
    ));
    Get.put<SearchTabController>(SearchTabController(
      GetProducts(FakeProductRepository()),
      GetProducers(FakeProducerRepository()),
    ));
    Get.put<ClubController>(ClubController());
    Get.put<ProfileController>(ProfileController(session, themeController));
  });

  tearDown(Get.reset);

  Widget wrap() => GetMaterialApp(
        theme: AppTheme.light,
        home: const ShellPage(),
      );

  // Bounded pumps (not pumpAndSettle): the Home tab's catalog load shows a
  // progress spinner that wouldn't settle within this shell-focused test. The
  // navigation bar renders on the first frame, which is all these tests check.
  testWidgets('renders the four navigation destinations', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.text('Início'), findsWidgets);
    expect(find.text('Buscar'), findsWidgets);
    expect(find.text('Clube'), findsWidgets);
    expect(find.text('Perfil'), findsWidgets);
  });

  testWidgets('tapping a destination changes the active tab', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(Get.find<ShellController>().currentIndex, 0);

    await tester.tap(find.text('Clube'));
    await tester.pump();

    expect(Get.find<ShellController>().currentIndex, 2);
  });
}
