import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/product.dart';
import '../entities/product_query.dart';
import '../repositories/product_repository.dart';

/// Lists catalog products matching a [ProductQuery] (search, filter, sort).
/// Backs the Home/Catalog and Search screens.
class GetProducts implements UseCase<List<Product>, ProductQuery> {
  const GetProducts(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<List<Product>>> call(ProductQuery params) =>
      _repository.getProducts(params);
}
