import '../../domain/core/result.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../mappers/review_mapper.dart';
import '../../seed/mock_data.dart';

/// Offline [ReviewRepository] backed by [MockData] (demo mode).
///
/// Keeps an in-memory, mutable list seeded from the mock reviews so that a
/// review written during the session shows up immediately in the list — the
/// same read-after-write behavior the Firestore implementation gives.
class InMemoryReviewRepository implements ReviewRepository {
  InMemoryReviewRepository() {
    const mapper = ReviewMapper();
    _reviews.addAll(MockData.reviews.map(mapper.toEntity));
  }

  final List<Review> _reviews = [];
  int _counter = 0;

  @override
  Future<Result<List<Review>>> getReviewsByProduct(String productId) async {
    final items = _reviews.where((r) => r.productId == productId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return success(items);
  }

  @override
  Future<Result<Review>> addReview(Review review) async {
    final stored = Review(
      id: 'rev_mem_${++_counter}',
      productId: review.productId,
      userId: review.userId,
      rating: review.rating,
      text: review.text,
      createdAt: review.createdAt,
      userName: review.userName,
      userPhotoUrl: review.userPhotoUrl,
    );
    _reviews.add(stored);
    return success(stored);
  }
}
