import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/session/session_controller.dart';

/// View-model for the Profile tab.
///
/// Reads identity and Club membership from the [SessionController] and exposes
/// the dark-mode toggle via the [ThemeController]. Owns sign-out, which clears
/// the session and returns to onboarding.
class ProfileController extends GetxController {
  ProfileController(this._session, this._theme);

  final SessionController _session;
  final ThemeController _theme;

  String get name => _session.currentUserName ?? 'Visitante';
  String get email => _session.currentUserEmail ?? '';
  String? get photoUrl => _session.currentUserPhotoUrl;
  bool get isClubMember => _session.isClubMember;
  int get followingCount => _session.following.length;

  /// Initials fallback for the avatar when there's no photo.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  bool get isDark => _theme.isDark;
  void setDarkMode(bool value) =>
      _theme.setMode(value ? ThemeMode.dark : ThemeMode.light);

  Future<void> signOut() async {
    await _session.signOut();
    Get.offAllNamed(AppRoutes.onboarding);
  }
}
