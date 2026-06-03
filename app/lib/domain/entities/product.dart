import 'enums.dart';

/// A cocoa byproduct in the catalog (the `products` Firestore collection).
///
/// Showcase only — there is intentionally no price, stock or checkout field.
class Product {
  const Product({
    required this.id,
    required this.producerId,
    required this.name,
    required this.byproductCategory,
    required this.description,
    this.photoUrls = const [],
    this.qualitySeals = const [],
    this.originLotId,
    this.rating = 0,
    this.reviewCount = 0,
    required this.createdAt,
  });

  final String id;
  final String producerId;
  final String name;
  final ByproductCategory byproductCategory;
  final String description;
  final List<String> photoUrls;
  final List<QualitySeal> qualitySeals;

  /// Links to the `origin_lots` document backing this product's traceability.
  final String? originLotId;

  /// Aggregate rating (0–5).
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  String? get coverPhotoUrl => photoUrls.isNotEmpty ? photoUrls.first : null;

  bool get hasTraceability => originLotId != null;
}
