import '../core/result.dart';
import '../entities/review.dart';

/// Read + write access to product reviews.
abstract interface class ReviewRepository {
  /// Reviews for a product, newest first.
  Future<Result<List<Review>>> getReviewsByProduct(String productId);

  /// Persists [review] and returns the stored entity (with assigned id).
  Future<Result<Review>> addReview(Review review);
}
