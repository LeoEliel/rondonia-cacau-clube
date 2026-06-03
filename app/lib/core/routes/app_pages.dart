import 'package:get/get.dart';

import '../../presentation/producer/bindings/producer_profile_binding.dart';
import '../../presentation/producer/pages/producer_profile_page.dart';
import '../../presentation/product_detail/bindings/product_detail_binding.dart';
import '../../presentation/product_detail/pages/product_detail_page.dart';
import '../../presentation/reviews/bindings/reviews_binding.dart';
import '../../presentation/reviews/pages/reviews_page.dart';
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
    // Remaining feature routes (onboarding, login, club) are registered here in
    // the following milestones.
  ];
}
