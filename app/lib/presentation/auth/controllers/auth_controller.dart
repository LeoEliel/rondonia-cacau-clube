import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/session/session_controller.dart';
import '../../../domain/core/result.dart';
import '../../../domain/core/usecase.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/sign_in_with_email.dart';
import '../../../domain/usecases/sign_in_with_google.dart';
import '../../../domain/usecases/sign_up_with_email.dart';

/// Drives both the login and sign-up forms (they share fields and the Google /
/// validation logic). On any successful authentication it hands the user to the
/// [SessionController] and replaces the navigation stack with the app shell, so
/// the auth flow is left behind.
class AuthController extends GetxController {
  AuthController(
    this._signInWithEmail,
    this._signUpWithEmail,
    this._signInWithGoogle,
    this._session,
  );

  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SessionController _session;

  final TextEditingController nameField = TextEditingController();
  final TextEditingController emailField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  void toggleObscure() => obscurePassword.toggle();

  Future<void> signIn() async {
    final email = emailField.text.trim();
    final password = passwordField.text;
    final validation = _validate(email: email, password: password);
    if (validation != null) {
      error.value = validation;
      return;
    }
    await _run(() => _signInWithEmail(
          EmailCredentials(email: email, password: password),
        ));
  }

  Future<void> signUp() async {
    final name = nameField.text.trim();
    final email = emailField.text.trim();
    final password = passwordField.text;
    final validation =
        _validate(name: name, email: email, password: password);
    if (validation != null) {
      error.value = validation;
      return;
    }
    await _run(() => _signUpWithEmail(
          SignUpData(name: name, email: email, password: password),
        ));
  }

  Future<void> signInWithGoogle() async {
    await _run(() => _signInWithGoogle(const NoParams()));
  }

  void forgotPassword() {
    Get.snackbar(
      AppStrings.forgotPassword,
      AppStrings.forgotPasswordInfo,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  /// Runs an auth action with shared loading / error handling, completing the
  /// session and navigating to the shell on success.
  Future<void> _run(Future<Result<User>> Function() action) async {
    if (loading.value) return;
    error.value = null;
    loading.value = true;
    final result = await action();
    loading.value = false;

    result.fold(
      (failure) => error.value = failure.message,
      (user) async {
        await _session.completeSignIn(user);
        // The controller is permanent (shared across login/signup), so reset the
        // form here rather than relying on disposal when leaving the auth flow.
        nameField.clear();
        emailField.clear();
        passwordField.clear();
        error.value = null;
        Get.offAllNamed(AppRoutes.shell);
      },
    );
  }

  String? _validate({String? name, required String email, required String password}) {
    if (name != null && name.isEmpty) return 'Informe seu nome.';
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      return 'Informe um e-mail válido.';
    }
    if (password.length < 6) {
      return 'A senha precisa ter ao menos 6 caracteres.';
    }
    return null;
  }

  @override
  void onClose() {
    nameField.dispose();
    emailField.dispose();
    passwordField.dispose();
    super.onClose();
  }
}
