import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/sign_in_with_email.dart';
import 'package:app/domain/usecases/sign_in_with_google.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/sign_up_with_email.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:app/presentation/auth/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fake_repositories.dart';

({AuthController controller, FakeAuthRepository authRepo}) _build() {
  final authRepo = FakeAuthRepository();
  final userRepo = FakeUserRepository();
  final session = SessionController(
    GetCurrentUser(authRepo),
    GetUser(userRepo),
    SignOut(authRepo),
    FollowProducer(userRepo),
    UnfollowProducer(userRepo),
  );
  final controller = AuthController(
    SignInWithEmail(authRepo),
    SignUpWithEmail(authRepo),
    SignInWithGoogle(authRepo),
    session,
  );
  return (controller: controller, authRepo: authRepo);
}

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  group('AuthController validation', () {
    test('rejects an invalid email without calling the use case', () async {
      final f = _build();
      f.controller.emailField.text = 'not-an-email';
      f.controller.passwordField.text = '123456';

      await f.controller.signIn();

      expect(f.controller.error.value, 'Informe um e-mail válido.');
      expect(f.authRepo.lastEmail, isNull);
    });

    test('rejects a short password', () async {
      final f = _build();
      f.controller.emailField.text = 'ana@email.com';
      f.controller.passwordField.text = '123';

      await f.controller.signIn();

      expect(f.controller.error.value,
          'A senha precisa ter ao menos 6 caracteres.');
      expect(f.authRepo.lastEmail, isNull);
    });

    test('requires a name on sign-up', () async {
      final f = _build();
      f.controller.nameField.text = '';
      f.controller.emailField.text = 'ana@email.com';
      f.controller.passwordField.text = '123456';

      await f.controller.signUp();

      expect(f.controller.error.value, 'Informe seu nome.');
    });
  });

  group('AuthController failure handling', () {
    test('forwards credentials and surfaces the failure message', () async {
      final f = _build();
      f.authRepo.signInResult =
          failure(const AuthFailure('E-mail ou senha incorretos.'));
      f.controller.emailField.text = 'ana@email.com';
      f.controller.passwordField.text = 'wrongpass';

      await f.controller.signIn();

      expect(f.authRepo.lastEmail, 'ana@email.com');
      expect(f.authRepo.lastPassword, 'wrongpass');
      expect(f.controller.error.value, 'E-mail ou senha incorretos.');
      expect(f.controller.loading.value, isFalse);
    });

    test('Google sign-in invokes the use case and reports failure', () async {
      final f = _build();
      f.authRepo.googleResult = failure(const AuthFailure('Cancelado.'));

      await f.controller.signInWithGoogle();

      expect(f.authRepo.didGoogle, isTrue);
      expect(f.controller.error.value, 'Cancelado.');
    });
  });
}
