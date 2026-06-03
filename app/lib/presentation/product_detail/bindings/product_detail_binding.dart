import 'package:get/get.dart';

import '../controllers/product_detail_controller.dart';

/// Binds the Product Detail screen. The product id arrives as the route
/// argument (`Get.toNamed(AppRoutes.productDetail, arguments: productId)`); the
/// use cases themselves are already registered globally by `DataBinding`.
class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(
        Get.find(),
        Get.find(),
        Get.find(),
        productId: Get.arguments as String,
      ),
    );
  }
}
