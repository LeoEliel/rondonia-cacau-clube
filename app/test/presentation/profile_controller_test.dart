import 'package:app/core/controllers/theme_controller.dart';
import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

Future<ProfileController> _build() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final theme = ThemeController(prefs);

  final authRepo = FakeAuthRepository()
    ..currentUserResult = success(Samples.user());
  final userRepo = FakeUserRepository();
  final session = SessionController(
    GetCurrentUser(authRepo),
    GetUser(userRepo),
    SignOut(authRepo),
    FollowProducer(userRepo),
    UnfollowProducer(userRepo),
  );
  await session.restore();

  return ProfileController(session, theme);
}

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  test('exposes the signed-in identity', () async {
    final controller = await _build();

    expect(controller.name, 'Ana Souza');
    expect(controller.email, 'ana@example.com');
    expect(controller.initials, 'AS');
    expect(controller.isClubMember, isTrue);
    expect(controller.followingCount, 1);
  });

  test('toggles dark mode through the theme controller', () async {
    final controller = await _build();

    expect(controller.isDark, isFalse);
    controller.setDarkMode(true);
    expect(controller.isDark, isTrue);
  });
}
