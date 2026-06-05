import 'package:app/core/constants/app_strings.dart';
import 'package:app/core/routes/app_routes.dart';
import 'package:app/core/session/session_controller.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/sign_in_with_email.dart';
import 'package:app/domain/usecases/sign_in_with_google.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/sign_up_with_email.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:app/presentation/auth/bindings/auth_binding.dart';
import 'package:app/presentation/auth/pages/login_page.dart';
import 'package:app/presentation/auth/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fake_repositories.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    final authRepo = FakeAuthRepository();
    final userRepo = FakeUserRepository();
    // AuthBinding resolves these via Get.find().
    Get.put<SessionController>(
      SessionController(
        GetCurrentUser(authRepo),
        GetUser(userRepo),
        SignOut(authRepo),
        FollowProducer(userRepo),
        UnfollowProducer(userRepo),
      ),
      permanent: true,
    );
    Get.put<SignInWithEmail>(SignInWithEmail(authRepo));
    Get.put<SignUpWithEmail>(SignUpWithEmail(authRepo));
    Get.put<SignInWithGoogle>(SignInWithGoogle(authRepo));
  });

  tearDown(Get.reset);

  // Mirrors the real route table for the auth flow: both routes share one
  // AuthController via AuthBinding, and the links toggle with Get.offNamed.
  Widget wrap() => GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.login,
        getPages: [
          GetPage(
            name: AppRoutes.login,
            page: () => const LoginPage(),
            binding: AuthBinding(),
          ),
          GetPage(
            name: AppRoutes.signup,
            page: () => const SignupPage(),
            binding: AuthBinding(),
          ),
        ],
      );

  testWidgets(
      'toggling login<->signup and typing never hits a disposed controller',
      (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    // Type on login.
    expect(find.text(AppStrings.loginTitle), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'ana@email.com');
    expect(tester.takeException(), isNull);

    // Go to sign-up: Get.offNamed replaces (and disposes) the login route.
    // The link sits at the bottom of the scroll view, so bring it into view.
    await tester.ensureVisible(find.text(AppStrings.goToSignUp));
    await tester.tap(find.text(AppStrings.goToSignUp));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.signupTitle), findsOneWidget);

    // The regression: this keystroke used to throw "TextEditingController was
    // used after being disposed" because the shared controller's fields were
    // torn down by the route swap.
    await tester.enterText(find.byType(TextField).first, 'Ana');
    expect(tester.takeException(), isNull);

    // Back to login, type again — still alive.
    await tester.ensureVisible(find.text(AppStrings.goToSignIn));
    await tester.tap(find.text(AppStrings.goToSignIn));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.loginTitle), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'ana2@email.com');
    expect(tester.takeException(), isNull);
  });

  // Reproduces the reported crash: from a previous screen, open the auth flow
  // with Get.toNamed (push), then pop back. The outgoing auth page is still
  // mounted while it animates out, so if the pop disposes the shared
  // controller's fields, the page's rebuild throws "used after being disposed".
  testWidgets('popping the auth route back to the previous screen is safe',
      (tester) async {
    Widget home() => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.signup),
              child: const Text('open-auth'),
            ),
          ),
        );

    await tester.pumpWidget(GetMaterialApp(
      theme: AppTheme.light,
      initialRoute: '/prev',
      getPages: [
        GetPage(name: '/prev', page: home),
        GetPage(
            name: AppRoutes.login,
            page: () => const LoginPage(),
            binding: AuthBinding()),
        GetPage(
            name: AppRoutes.signup,
            page: () => const SignupPage(),
            binding: AuthBinding()),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open-auth'));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.signupTitle), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Ana');
    expect(tester.takeException(), isNull);

    // Pop back to the previous screen — the reported crash point.
    Get.back();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('open-auth'), findsOneWidget);
  });
}
