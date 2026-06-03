import 'package:get/get.dart';

import '../controllers/reviews_controller.dart';

/// Binds the Reviews screen. A [ReviewsArgs] arrives as the route argument
/// (`Get.toNamed(AppRoutes.reviews, arguments: ReviewsArgs(...))`); the use
/// cases and [SessionController] are already registered globally.
class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewsController>(
      () => ReviewsController(
        Get.find(),
        Get.find(),
        Get.find(),
        args: Get.arguments as ReviewsArgs,
      ),
    );
  }
}
