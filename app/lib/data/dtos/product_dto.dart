import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/firestore_codec.dart';

/// Firestore wire model for a `products` document. Holds raw shapes (enums as
/// strings, dates as [Timestamp]); conversion to/from the domain entity lives
/// in `ProductMapper`.
class ProductDto {
  const ProductDto({
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
  final String byproductCategory;
  final String description;
  final List<String> photoUrls;
  final List<String> qualitySeals;
  final String? originLotId;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  factory ProductDto.fromMap(String id, Map<String, dynamic> map) {
    return ProductDto(
      id: id,
      producerId: FsCodec.asString(map['producerId']),
      name: FsCodec.asString(map['name']),
      byproductCategory: FsCodec.asString(map['byproductCategory'], 'other'),
      description: FsCodec.asString(map['description']),
      photoUrls: FsCodec.asStringList(map['photoUrls']),
      qualitySeals: FsCodec.asStringList(map['qualitySeals']),
      originLotId: FsCodec.asStringOrNull(map['originLotId']),
      rating: FsCodec.asDouble(map['rating']),
      reviewCount: FsCodec.asInt(map['reviewCount']),
      createdAt: FsCodec.asDate(map['createdAt']),
    );
  }

  factory ProductDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ProductDto.fromMap(doc.id, doc.data() ?? const {});

  Map<String, dynamic> toMap() {
    return {
      'producerId': producerId,
      'name': name,
      'byproductCategory': byproductCategory,
      'description': description,
      'photoUrls': photoUrls,
      'qualitySeals': qualitySeals,
      'originLotId': originLotId,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': FsCodec.toTimestamp(createdAt),
    };
  }
}
