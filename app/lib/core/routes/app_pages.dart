import 'package:get/get.dart';

import '../../presentation/shell/bindings/shell_binding.dart';
import '../../presentation/shell/pages/shell_page.dart';
import 'app_routes.dart';

/// GetX route table. Each [GetPage] pairs a route with its page widget and a
/// [Bindings] so dependencies are lazily resolved only when the route opens
/// (dependency inversion at the navigation layer).
abstract final class AppPages {
  AppPages._();

  static const String initial = AppRoutes.shell;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.shell,
      page: () => const ShellPage(),
      binding: ShellBinding(),
    ),
    // Feature routes (onboarding, login, product detail, producer, club,
    // reviews) are registered here in the following milestones.
  ];
}
