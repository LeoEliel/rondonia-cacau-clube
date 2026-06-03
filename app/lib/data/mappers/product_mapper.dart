import '../../domain/entities/enums.dart';
import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';

/// Converts between [ProductDto] (wire) and [Product] (domain), handling enum
/// (de)serialization. Stateless and `const` — repositories hold one instance.
class ProductMapper {
  const ProductMapper();

  Product toEntity(ProductDto dto) {
    return Product(
      id: dto.id,
      producerId: dto.producerId,
      name: dto.name,
      byproductCategory: ByproductCategory.fromWire(dto.byproductCategory),
      description: dto.description,
      photoUrls: dto.photoUrls,
      qualitySeals: dto.qualitySeals
          .map(QualitySeal.fromWire)
          .whereType<QualitySeal>()
          .toList(),
      originLotId: dto.originLotId,
      rating: dto.rating,
      reviewCount: dto.reviewCount,
      createdAt: dto.createdAt,
    );
  }

  ProductDto toDto(Product e) {
    return ProductDto(
      id: e.id,
      producerId: e.producerId,
      name: e.name,
      byproductCategory: e.byproductCategory.wireKey,
      description: e.description,
      photoUrls: e.photoUrls,
      qualitySeals: e.qualitySeals.map((s) => s.wireKey).toList(),
      originLotId: e.originLotId,
      rating: e.rating,
      reviewCount: e.reviewCount,
      createdAt: e.createdAt,
    );
  }
}
