import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/bindings/initial_binding.dart';
import '../core/constants/app_strings.dart';
import '../core/routes/app_pages.dart';
import '../core/theme/app_theme.dart';

/// Root application widget.
///
/// Uses [GetMaterialApp] so GetX owns navigation (named [AppPages] routes),
/// dependency injection (the [InitialBinding]) and reactive theming. The active
/// [ThemeMode] is controlled by `ThemeController` via `Get.changeThemeMode`.
class CacauClubeApp extends StatelessWidget {
  const CacauClubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
