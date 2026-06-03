import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../dtos/review_dto.dart';

/// Firestore-backed review reads/writes.
class ReviewRemoteDataSource {
  ReviewRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.reviews);

  Future<List<ReviewDto>> fetchByProduct(String productId) async {
    // No orderBy on the query (avoids a composite index); sort client-side.
    final snap = await _col.where('productId', isEqualTo: productId).get();
    final items = snap.docs.map(ReviewDto.fromDoc).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  /// Adds a review and bumps the product's `reviewCount`. Returns the stored
  /// DTO with its generated document id.
  Future<ReviewDto> add(ReviewDto dto) async {
    final ref = await _col.add(dto.toMap());
    await _firestore
        .collection(FirestorePaths.products)
        .doc(dto.productId)
        .update({'reviewCount': FieldValue.increment(1)});
    return dto.copyWith(id: ref.id);
  }
}
