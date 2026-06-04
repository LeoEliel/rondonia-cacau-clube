import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/brand_mark.dart';

/// Brand glyph + title + subtitle lockup shared by the login and sign-up
/// screens (design 02).
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const BrandMark(size: 84),
        const SizedBox(height: AppSpacing.xl),
        Text(title, textAlign: TextAlign.center, style: theme.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// Labelled text field matching the design's field style (leading icon,
/// optional trailing widget for the password reveal toggle).
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.suffix,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

/// Inline error message shown under the form on a failed attempt.
class AuthError extends StatelessWidget {
  const AuthError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: AppRadii.brSm,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

/// "—— ou continue com ——" separator above the social buttons.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            AppStrings.orContinueWith,
            style: theme.textTheme.labelMedium,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// White, outlined Google button with the multicolor "G" glyph.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onPressed, this.enabled = true});

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: scheme.outlineVariant),
      ),
      icon: const _GoogleGlyph(),
      label: const Text(AppStrings.continueWithGoogle),
    );
  }
}

/// Small spinner shown inside a primary button while a request is running.
class ButtonSpinner extends StatelessWidget {
  const ButtonSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.4,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

/// Minimal Google "G" rendered without an asset dependency.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
        letterSpacing: 0,
      ),
    );
  }
}
