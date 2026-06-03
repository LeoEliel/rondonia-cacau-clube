import 'package:app/domain/core/result.dart';
import 'package:app/domain/core/usecase.dart';
import 'package:app/domain/usecases/get_origin_lot.dart';
import 'package:app/domain/usecases/get_producer_by_id.dart';
import 'package:app/domain/usecases/get_producers.dart';
import 'package:app/domain/usecases/get_product_reviews.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';
import '../../helpers/samples.dart';

void main() {
  group('GetProducers', () {
    test('returns the producers list', () async {
      final repo = FakeProducerRepository()
        ..getProducersResult = success([Samples.producer()]);

      final result = await GetProducers(repo)(const NoParams());

      expect(result.getOrElse(() => const []).length, 1);
    });
  });

  group('GetProducerById', () {
    test('forwards the id and returns the producer', () async {
      final repo = FakeProducerRepository()
        ..getProducerByIdResult = success(Samples.producer(id: 'prod_9'));

      final result = await GetProducerById(repo)('prod_9');

      expect(repo.lastId, 'prod_9');
      expect(result.getOrElse(() => Samples.producer()).id, 'prod_9');
    });
  });

  group('GetProductReviews', () {
    test('forwards the productId and returns reviews', () async {
      final repo = FakeReviewRepository()
        ..reviewsResult = success([Samples.review()]);

      final result = await GetProductReviews(repo)('prd_1');

      expect(repo.lastProductId, 'prd_1');
      expect(result.getOrElse(() => const []).length, 1);
    });
  });

  group('GetOriginLot', () {
    test('forwards the lot id', () async {
      final repo = FakeOriginLotRepository()
        ..result = success(Samples.originLot(id: 'lot_x'));

      final result = await GetOriginLot(repo)('lot_x');

      expect(repo.lastId, 'lot_x');
      expect(result.isRight(), isTrue);
    });
  });

  group('GetUser', () {
    test('returns the user', () async {
      final repo = FakeUserRepository()..userResult = success(Samples.user());

      final result = await GetUser(repo)('user_ana');

      expect(result.getOrElse(() => Samples.user()).uid, 'user_ana');
    });
  });
}
