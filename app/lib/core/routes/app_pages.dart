import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../presentation/auth/bindings/auth_binding.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/signup_page.dart';
import '../../presentation/onboarding/bindings/onboarding_binding.dart';
import '../../presentation/onboarding/pages/onboarding_page.dart';
import '../../presentation/producer/bindings/producer_profile_binding.dart';
import '../../presentation/producer/pages/producer_profile_page.dart';
import '../../presentation/product_detail/bindings/product_detail_binding.dart';
import '../../presentation/product_detail/pages/product_detail_page.dart';
import '../../presentation/reviews/bindings/reviews_binding.dart';
import '../../presentation/reviews/pages/reviews_page.dart';
import '../../presentation/shell/bindings/shell_binding.dart';
import '../../presentation/shell/pages/shell_page.dart';
import '../session/session_controller.dart';
import 'app_routes.dart';

/// GetX route table. Each [GetPage] pairs a route with its page widget and a
/// [Bindings] so dependencies are lazily resolved only when the route opens
/// (dependency inversion at the navigation layer).
abstract final class AppPages {
  AppPages._();

  /// The app opens on onboarding; the shell redirects anonymous users back here
  /// (see [_requireAuth]) and authenticated sign-in replaces the stack with it.
  static const String initial = AppRoutes.onboarding;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
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
    GetPage(
      name: AppRoutes.shell,
      page: () => const ShellPage(),
      binding: ShellBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.producer,
      page: () => const ProducerProfilePage(),
      binding: ProducerProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.reviews,
      page: () => const ReviewsPage(),
      binding: ReviewsBinding(),
    ),
  ];

}

/// Keeps the authenticated area behind a session: anonymous users hitting the
/// shell are redirected to onboarding.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final session = Get.find<SessionController>();
    return session.isAuthenticated
        ? null
        : const RouteSettings(name: AppRoutes.onboarding);
  }
}
