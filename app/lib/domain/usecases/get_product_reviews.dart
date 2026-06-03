import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

/// Lists a product's reviews (newest first) for the Reviews screen.
class GetProductReviews implements UseCase<List<Review>, String> {
  const GetProductReviews(this._repository);

  final ReviewRepository _repository;

  @override
  Future<Result<List<Review>>> call(String params) =>
      _repository.getReviewsByProduct(params);
}
