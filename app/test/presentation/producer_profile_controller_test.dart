import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/producer.dart';
import 'package:app/domain/entities/product.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_producer_by_id.dart';
import 'package:app/domain/usecases/get_products_by_producer.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:app/presentation/producer/controllers/producer_profile_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

Future<SessionController> _session(FakeUserRepository userRepo) async {
  final authRepo = FakeAuthRepository()
    ..currentUserResult = success(Samples.user());
  final session = SessionController(
    GetCurrentUser(authRepo),
    GetUser(userRepo),
    SignOut(authRepo),
    FollowProducer(userRepo),
    UnfollowProducer(userRepo),
  );
  await session.restore();
  return session;
}

Future<({ProducerProfileController controller, SessionController session})>
    _build({
  Result<Producer>? producerResult,
  Result<List<Product>>? productsResult,
  String producerId = 'prod_1',
}) async {
  final userRepo = FakeUserRepository()..userResult = success(Samples.user());
  final session = await _session(userRepo);

  final producerRepo = FakeProducerRepository()
    ..getProducerByIdResult =
        producerResult ?? success(Samples.producer(id: producerId));
  final productRepo = FakeProductRepository()
    ..byProducerResult = productsResult ?? success([Samples.product()]);

  return (
    controller: ProducerProfileController(
      GetProducerById(producerRepo),
      GetProductsByProducer(productRepo),
      session,
      producerId: producerId,
    ),
    session: session,
  );
}

void main() {
  group('ProducerProfileController.load', () {
    test('loads producer + products on success', () async {
      final f = await _build();

      await f.controller.load();

      expect(f.controller.status, ProducerStatus.loaded);
      expect(f.controller.producer?.id, 'prod_1');
      expect(f.controller.productCount, 1);
    });

    test('errors when the producer cannot be loaded', () async {
      final f = await _build(producerResult: failure(const NotFoundFailure()));

      await f.controller.load();

      expect(f.controller.status, ProducerStatus.error);
      expect(f.controller.errorMessage, isNotEmpty);
    });

    test('renders (degraded) when the product list fails', () async {
      final f = await _build(productsResult: failure(const NetworkFailure()));

      await f.controller.load();

      expect(f.controller.status, ProducerStatus.loaded);
      expect(f.controller.products, isEmpty);
    });
  });

  group('ProducerProfileController follow', () {
    test('follower count moves with the current user toggle', () async {
      // Seeded producer has followerCount 0; the demo user already follows it.
      final f = await _build(
        producerResult: success(
          Samples.producer().copyWithFollowers(120),
        ),
      );
      await f.controller.load();

      // Already following at open → baseline reflects the aggregate as-is.
      expect(f.controller.isFollowing, isTrue);
      final atOpen = f.controller.followerCount;

      await f.controller.toggleFollow();

      expect(f.controller.isFollowing, isFalse);
      expect(f.controller.followerCount, atOpen - 1);
    });
  });
}

extension on Producer {
  /// Test helper: clone with a different aggregate follower count.
  Producer copyWithFollowers(int count) => Producer(
        id: id,
        name: name,
        type: type,
        bio: bio,
        story: story,
        municipality: municipality,
        geo: geo,
        certifications: certifications,
        qualitySeals: qualitySeals,
        photoUrls: photoUrls,
        followerCount: count,
        rating: rating,
      );
}
