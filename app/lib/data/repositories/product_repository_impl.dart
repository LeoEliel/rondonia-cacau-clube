import '../../domain/core/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_query.dart';
import '../../domain/repositories/product_repository.dart';
import '../core/firestore_guard.dart';
import '../datasources/product_remote_data_source.dart';
import '../mappers/product_mapper.dart';

/// [ProductRepository] backed by Firestore. Honors the interface contract:
/// always returns a [Result], translating data-layer errors into `Failure`s
/// (Liskov substitutability for any consumer of the interface).
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._ds);

  final ProductRemoteDataSource _ds;
  final ProductMapper _mapper = const ProductMapper();

  @override
  Future<Result<List<Product>>> getProducts(ProductQuery query) {
    return guardFirestore(() async {
      final dtos = await _ds.fetchProducts(query);
      return dtos.map(_mapper.toEntity).toList();
    });
  }

  @override
  Future<Result<Product>> getProductById(String id) {
    return guardFirestore(() async => _mapper.toEntity(
          await _ds.fetchProductById(id),
        ));
  }

  @override
  Future<Result<List<Product>>> getProductsByProducer(String producerId) {
    return guardFirestore(() async {
      final dtos = await _ds.fetchProductsByProducer(producerId);
      return dtos.map(_mapper.toEntity).toList();
    });
  }
}
