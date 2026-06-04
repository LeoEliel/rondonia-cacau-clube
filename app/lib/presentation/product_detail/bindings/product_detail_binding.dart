import 'package:get/get.dart';

import '../controllers/product_detail_controller.dart';

/// Binds the Product Detail screen. The product id arrives as a route URL
/// parameter (`/product?id=…`) with the in-memory `arguments` as a fast path.
/// Reading `parameters` first keeps the screen working across a web refresh /
/// back navigation (which drop `arguments`); a missing id degrades to a
/// "not found" state rather than throwing. Use cases are registered globally.
class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    final id = Get.parameters['id'] ?? (Get.arguments as String?) ?? '';
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(
        Get.find(),
        Get.find(),
        Get.find(),
        productId: id,
      ),
    );
  }
}
