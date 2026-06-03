import '../core/result.dart';
import '../entities/product.dart';
import '../entities/product_query.dart';

/// Read access to the cocoa byproduct catalog. Focused interface (ISP):
/// only catalog concerns live here.
abstract interface class ProductRepository {
  /// Returns products matching [query] (search text, category, seals, sort).
  Future<Result<List<Product>>> getProducts(ProductQuery query);

  Future<Result<Product>> getProductById(String id);

  Future<Result<List<Product>>> getProductsByProducer(String producerId);
}
