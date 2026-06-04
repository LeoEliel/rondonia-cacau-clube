import 'package:get/get.dart';

import '../controllers/reviews_controller.dart';

/// Binds the Reviews screen. [ReviewsArgs] arrives as the in-memory route
/// argument (fast path); on a web refresh / back navigation that drops it, the
/// args are rebuilt from the route URL parameters (`/reviews?id=…&name=…`) so
/// the screen keeps working instead of throwing. Use cases and
/// [SessionController] are registered globally.
class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    final args = (Get.arguments as ReviewsArgs?) ??
        ReviewsArgs.fromParams(Get.parameters);
    Get.lazyPut<ReviewsController>(
      () => ReviewsController(
        Get.find(),
        Get.find(),
        Get.find(),
        args: args,
      ),
    );
  }
}
