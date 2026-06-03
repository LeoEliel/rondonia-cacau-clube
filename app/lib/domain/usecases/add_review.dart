import '../core/failure.dart';
import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

/// Validates and persists a new review. Encapsulates the rating/text business
/// rules so every entry point (UI, future API) enforces them identically.
class AddReview implements UseCase<Review, AddReviewParams> {
  const AddReview(this._repository);

  final ReviewRepository _repository;

  @override
  Future<Result<Review>> call(AddReviewParams params) async {
    if (params.rating < 1 || params.rating > 5) {
      return failure(const ValidationFailure('A nota deve estar entre 1 e 5.'));
    }
    if (params.text.trim().isEmpty) {
      return failure(const ValidationFailure('Escreva um comentário.'));
    }

    final review = Review(
      id: '', // assigned by the data layer
      productId: params.productId,
      userId: params.userId,
      rating: params.rating,
      text: params.text.trim(),
      createdAt: DateTime.now(),
      userName: params.userName,
      userPhotoUrl: params.userPhotoUrl,
    );
    return _repository.addReview(review);
  }
}

/// Input for [AddReview].
class AddReviewParams {
  const AddReviewParams({
    required this.productId,
    required this.userId,
    required this.rating,
    required this.text,
    this.userName,
    this.userPhotoUrl,
  });

  final String productId;
  final String userId;
  final int rating;
  final String text;
  final String? userName;
  final String? userPhotoUrl;
}
