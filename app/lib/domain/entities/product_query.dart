import 'enums.dart';

/// Immutable search/filter criteria for catalog queries.
///
/// A dedicated value object (rather than a long parameter list) keeps
/// `ProductRepository.getProducts` open for new filters without changing its
/// signature, and is trivial to construct in controllers and tests.
class ProductQuery {
  const ProductQuery({
    this.text,
    this.category,
    this.seals = const [],
    this.producerId,
    this.sort = ProductSort.recent,
  });

  /// Free-text search over product name/description.
  final String? text;
  final ByproductCategory? category;
  final List<QualitySeal> seals;
  final String? producerId;
  final ProductSort sort;

  bool get isEmpty =>
      (text == null || text!.trim().isEmpty) &&
      category == null &&
      seals.isEmpty &&
      producerId == null;

  ProductQuery copyWith({
    String? text,
    ByproductCategory? category,
    List<QualitySeal>? seals,
    String? producerId,
    ProductSort? sort,
  }) {
    return ProductQuery(
      text: text ?? this.text,
      category: category ?? this.category,
      seals: seals ?? this.seals,
      producerId: producerId ?? this.producerId,
      sort: sort ?? this.sort,
    );
  }
}
