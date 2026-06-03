import 'package:get/get.dart';

import '../../../core/session/session_controller.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/usecases/add_review.dart';
import '../../../domain/usecases/get_product_reviews.dart';

enum ReviewsStatus { loading, loaded, error }

/// Route argument for the Reviews screen: the product to review plus its
/// aggregate stats (already known by the caller) so the summary header renders
/// without re-fetching the product.
class ReviewsArgs {
  const ReviewsArgs({
    required this.productId,
    required this.productName,
    required this.aggregateRating,
    required this.aggregateCount,
  });

  final String productId;
  final String productName;
  final double aggregateRating;
  final int aggregateCount;
}

/// View-model for the product Reviews screen.
///
/// Loads a product's reviews through [GetProductReviews] and submits new ones
/// via [AddReview] (which enforces the rating/text rules). The headline numbers
/// come from the product aggregate passed in [ReviewsArgs]; the star
/// distribution histogram and the list reflect the reviews actually loaded.
class ReviewsController extends GetxController {
  ReviewsController(
    this._getProductReviews,
    this._addReview,
    this._session, {
    required this.args,
  });

  final GetProductReviews _getProductReviews;
  final AddReview _addReview;
  final SessionController _session;
  final ReviewsArgs args;

  final Rx<ReviewsStatus> _status = ReviewsStatus.loading.obs;
  final RxList<Review> _reviews = <Review>[].obs;
  final RxString _error = ''.obs;

  /// In-progress star selection for the "Como foi sua experiência?" control.
  final RxInt draftRating = 0.obs;
  final RxBool submitting = false.obs;

  ReviewsStatus get status => _status.value;
  List<Review> get reviews => _reviews;
  String get errorMessage => _error.value;

  String get productName => args.productName;
  double get averageRating => args.aggregateRating;
  int get totalCount => args.aggregateCount;

  /// Count of loaded reviews per star (1–5).
  Map<int, int> get distribution {
    final counts = {for (var s = 1; s <= 5; s++) s: 0};
    for (final r in _reviews) {
      final star = r.rating.clamp(1, 5);
      counts[star] = (counts[star] ?? 0) + 1;
    }
    return counts;
  }

  /// Total loaded reviews (denominator for the histogram bars).
  int get loadedCount => _reviews.length;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _status.value = ReviewsStatus.loading;
    final result = await _getProductReviews(args.productId);
    result.fold(
      (failure) {
        _error.value = failure.message;
        _status.value = ReviewsStatus.error;
      },
      (reviews) {
        _reviews.assignAll(reviews);
        _status.value = ReviewsStatus.loaded;
      },
    );
  }

  void setDraftRating(int rating) => draftRating.value = rating;

  /// Submits a review for the current draft rating + [text]. Returns `null` on
  /// success or a user-facing error message to surface in the UI.
  Future<String?> submit(String text) async {
    submitting.value = true;
    final result = await _addReview(AddReviewParams(
      productId: args.productId,
      userId: _session.currentUserId,
      rating: draftRating.value,
      text: text,
      userName: _session.currentUserName,
      userPhotoUrl: _session.currentUserPhotoUrl,
    ));
    submitting.value = false;

    return result.fold(
      (failure) => failure.message,
      (review) {
        _reviews.insert(0, review);
        draftRating.value = 0;
        return null;
      },
    );
  }
}
