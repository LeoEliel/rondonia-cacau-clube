import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Lists a producer's products for the Producer Profile screen.
class GetProductsByProducer implements UseCase<List<Product>, String> {
  const GetProductsByProducer(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<List<Product>>> call(String params) =>
      _repository.getProductsByProducer(params);
}
