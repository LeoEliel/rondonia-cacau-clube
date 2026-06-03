import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/review.dart';
import 'package:app/domain/usecases/add_review.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_product_reviews.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:app/presentation/reviews/controllers/reviews_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

const _args = ReviewsArgs(
  productId: 'prd_1',
  productName: 'Mel de Cacau Puro',
  aggregateRating: 4.9,
  aggregateCount: 3,
);

Future<({ReviewsController controller, FakeReviewRepository reviewRepo})> _build({
  Result<List<Review>>? reviewsResult,
  Result<Review>? addResult,
}) async {
  final userRepo = FakeUserRepository()..userResult = success(Samples.user());
  final session = SessionController(
    GetUser(userRepo),
    FollowProducer(userRepo),
    UnfollowProducer(userRepo),
  );
  await session.load();

  final reviewRepo = FakeReviewRepository()
    ..reviewsResult = reviewsResult ?? success([Samples.review()])
    ..addResult = addResult ?? success(Samples.review(id: 'rev_new'));

  return (
    controller: ReviewsController(
      GetProductReviews(reviewRepo),
      AddReview(reviewRepo),
      session,
      args: _args,
    ),
    reviewRepo: reviewRepo,
  );
}

void main() {
  group('ReviewsController.load', () {
    test('loads reviews and forwards the product id', () async {
      final f = await _build();

      await f.controller.load();

      expect(f.controller.status, ReviewsStatus.loaded);
      expect(f.controller.reviews, hasLength(1));
      expect(f.reviewRepo.lastProductId, 'prd_1');
      // Histogram uses loaded reviews; the single sample is 5 stars.
      expect(f.controller.distribution[5], 1);
      expect(f.controller.loadedCount, 1);
    });

    test('errors when the reviews fail to load', () async {
      final f = await _build(reviewsResult: failure(const NetworkFailure()));

      await f.controller.load();

      expect(f.controller.status, ReviewsStatus.error);
      expect(f.controller.errorMessage, isNotEmpty);
    });
  });

  group('ReviewsController.submit', () {
    test('inserts the new review and resets the draft on success', () async {
      final f = await _build();
      await f.controller.load();
      f.controller.setDraftRating(5);

      final error = await f.controller.submit('Maravilhoso!');

      expect(error, isNull);
      expect(f.controller.reviews.first.id, 'rev_new');
      expect(f.controller.draftRating.value, 0);
      // The current (demo) user identity is attached to the submission.
      expect(f.reviewRepo.lastAdded?.userId, 'user_ana');
      expect(f.reviewRepo.lastAdded?.rating, 5);
    });

    test('surfaces the validation message and keeps the list unchanged',
        () async {
      // No rating selected → AddReview rejects before touching the repository.
      final f = await _build();
      await f.controller.load();
      f.controller.setDraftRating(0);

      final error = await f.controller.submit('');

      expect(error, isNotNull);
      expect(f.reviewRepo.lastAdded, isNull);
      expect(f.controller.reviews, hasLength(1));
    });
  });
}
