import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the active [ThemeMode] and persists the user's choice.
///
/// Registered permanently in the initial binding so the whole app can react to
/// theme changes via GetX without rebuilding the widget tree manually.
class ThemeController extends GetxController {
  ThemeController(this._prefs);

  static const String _storageKey = 'theme_mode';

  final SharedPreferences _prefs;

  final Rx<ThemeMode> _mode = ThemeMode.system.obs;
  ThemeMode get mode => _mode.value;

  bool get isDark => _mode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final stored = _prefs.getString(_storageKey);
    _mode.value = switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    Get.changeThemeMode(_mode.value);
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode.value = mode;
    Get.changeThemeMode(mode);
    await _prefs.setString(_storageKey, mode.name);
  }

  Future<void> toggle() =>
      setMode(isDark ? ThemeMode.light : ThemeMode.dark);
}
