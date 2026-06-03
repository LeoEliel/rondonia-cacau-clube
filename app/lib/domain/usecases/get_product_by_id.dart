import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Fetches a single product for the Product Detail screen.
class GetProductById implements UseCase<Product, String> {
  const GetProductById(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<Product>> call(String params) =>
      _repository.getProductById(params);
}
