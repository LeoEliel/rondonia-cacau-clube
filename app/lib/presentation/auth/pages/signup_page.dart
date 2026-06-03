import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_components.dart';

/// Account creation screen (design 02 variant): name + email + password,
/// Google, and a link back to sign-in.
class SignupPage extends GetView<AuthController> {
  const SignupPage({super.key});

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
                title: AppStrings.signupTitle,
                subtitle: AppStrings.signupSubtitle,
              ),
              const SizedBox(height: AppSpacing.sect),
              AuthTextField(
                label: AppStrings.fieldName,
                hint: AppStrings.fieldNameHint,
                controller: controller.nameField,
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.lg),
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
                  onSubmitted: (_) => controller.signUp(),
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
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => controller.error.value == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AuthError(message: controller.error.value!),
                      ),
              ),
              Obx(
                () => FilledButton(
                  onPressed: controller.loading.value ? null : controller.signUp,
                  child: controller.loading.value
                      ? const ButtonSpinner()
                      : const Text(AppStrings.signUpAction),
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
                    AppStrings.haveAccountPrompt,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.login),
                    child: const Text(AppStrings.goToSignIn),
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
