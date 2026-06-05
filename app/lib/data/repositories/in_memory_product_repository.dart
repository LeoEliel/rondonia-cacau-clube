import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_query.dart';
import '../../domain/repositories/product_repository.dart';
import '../mappers/product_mapper.dart';
import '../../seed/mock_data.dart';

/// Offline [ProductRepository] backed by [MockData]. Used in demo mode
/// (`--dart-define=DEMO=true`) so the UI can be explored without a seeded
/// Firestore. Mirrors the query semantics of the Firestore data source.
class InMemoryProductRepository implements ProductRepository {
  final ProductMapper _mapper = const ProductMapper();

  List<Product> get _all => MockData.products.map(_mapper.toEntity).toList();

  @override
  Future<Result<List<Product>>> getProducts(ProductQuery query) async {
    var items = _all;

    if (query.producerId != null) {
      items = items.where((p) => p.producerId == query.producerId).toList();
    }
    if (query.category != null) {
      items = items
          .where((p) => p.byproductCategory == query.category)
          .toList();
    }
    if (query.seals.isNotEmpty) {
      final seals = query.seals.toSet();
      items = items.where((p) => p.qualitySeals.any(seals.contains)).toList();
    }
    final text = query.text?.trim().toLowerCase();
    if (text != null && text.isNotEmpty) {
      items = items
          .where(
            (p) =>
                p.name.toLowerCase().contains(text) ||
                p.description.toLowerCase().contains(text),
          )
          .toList();
    }

    switch (query.sort) {
      case ProductSort.recent:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case ProductSort.topRated:
        items.sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSort.nameAsc:
        items.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
    }
    return success(items);
  }

  @override
  Future<Result<Product>> getProductById(String id) async {
    final match = _all.where((p) => p.id == id);
    return match.isEmpty
        ? failure(NotFoundFailure('Produto "$id" não encontrado.'))
        : success(match.first);
  }

  @override
  Future<Result<List<Product>>> getProductsByProducer(String producerId) async {
    final items = _all.where((p) => p.producerId == producerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return success(items);
  }
}
