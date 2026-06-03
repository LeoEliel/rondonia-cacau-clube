import '../../domain/core/result.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../core/firestore_guard.dart';
import '../datasources/review_remote_data_source.dart';
import '../mappers/review_mapper.dart';

/// [ReviewRepository] backed by Firestore.
class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl(this._ds);

  final ReviewRemoteDataSource _ds;
  final ReviewMapper _mapper = const ReviewMapper();

  @override
  Future<Result<List<Review>>> getReviewsByProduct(String productId) {
    return guardFirestore(() async {
      final dtos = await _ds.fetchByProduct(productId);
      return dtos.map(_mapper.toEntity).toList();
    });
  }

  @override
  Future<Result<Review>> addReview(Review review) {
    return guardFirestore(() async {
      final saved = await _ds.add(_mapper.toDto(review));
      return _mapper.toEntity(saved);
    });
  }
}
