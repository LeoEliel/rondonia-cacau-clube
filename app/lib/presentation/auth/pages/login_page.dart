import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_components.dart';

/// Sign-in screen (design 02): email + password, Google, and a link to
/// sign-up.
class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pad,
            AppSpacing.sm,
            AppSpacing.pad,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: AppStrings.loginTitle,
                subtitle: AppStrings.loginSubtitle,
              ),
              const SizedBox(height: AppSpacing.sect),
              AuthTextField(
                label: AppStrings.fieldEmail,
                hint: AppStrings.fieldEmailHint,
                controller: controller.emailField,
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => AuthTextField(
                  label: AppStrings.fieldPassword,
                  hint: AppStrings.fieldPasswordHint,
                  controller: controller.passwordField,
                  icon: Icons.lock_outline,
                  obscureText: controller.obscurePassword.value,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => controller.signIn(),
                  suffix: IconButton(
                    onPressed: controller.toggleObscure,
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.forgotPassword,
                  child: const Text(AppStrings.forgotPassword),
                ),
              ),
              Obx(
                () => controller.error.value == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AuthError(message: controller.error.value!),
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Obx(
                () => FilledButton(
                  onPressed: controller.loading.value ? null : controller.signIn,
                  child: controller.loading.value
                      ? const ButtonSpinner()
                      : const Text(AppStrings.signInAction),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const OrDivider(),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => GoogleSignInButton(
                  onPressed: controller.signInWithGoogle,
                  enabled: !controller.loading.value,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.noAccountPrompt,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.signup),
                    child: const Text(AppStrings.goToSignUp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
