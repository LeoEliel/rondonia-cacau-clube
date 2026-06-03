import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/enums.dart';
import 'package:app/domain/entities/product_query.dart';
import 'package:app/domain/usecases/get_product_by_id.dart';
import 'package:app/domain/usecases/get_products.dart';
import 'package:app/domain/usecases/get_products_by_producer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';
import '../../helpers/samples.dart';

void main() {
  late FakeProductRepository repo;

  setUp(() => repo = FakeProductRepository());

  group('GetProducts', () {
    test('forwards the query and returns the products', () async {
      repo.getProductsResult = success([Samples.product()]);

      final result = await GetProducts(repo)(
        const ProductQuery(text: 'mel', category: ByproductCategory.cocoaHoney),
      );

      expect(repo.lastQuery?.text, 'mel');
      expect(repo.lastQuery?.category, ByproductCategory.cocoaHoney);
      expect(result.getOrElse(() => const []).length, 1);
    });

    test('propagates a repository failure', () async {
      repo.getProductsResult = failure(const NetworkFailure());

      final result = await GetProducts(repo)(const ProductQuery());

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetProductById', () {
    test('forwards the id and returns the product', () async {
      repo.getProductByIdResult = success(Samples.product(id: 'prd_42'));

      final result = await GetProductById(repo)('prd_42');

      expect(repo.lastId, 'prd_42');
      expect(result.getOrElse(() => Samples.product()).id, 'prd_42');
    });

    test('propagates a not-found failure', () async {
      repo.getProductByIdResult = failure(const NotFoundFailure());

      final result = await GetProductById(repo)('missing');

      result.fold(
        (f) => expect(f, isA<NotFoundFailure>()),
        (_) => fail('expected a failure'),
      );
    });
  });

  group('GetProductsByProducer', () {
    test('forwards the producerId', () async {
      repo.byProducerResult = success([Samples.product()]);

      final result = await GetProductsByProducer(repo)('prod_1');

      expect(repo.lastProducerId, 'prod_1');
      expect(result.getOrElse(() => const []).length, 1);
    });
  });
}
