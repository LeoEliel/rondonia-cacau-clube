import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/origin_lot.dart';
import 'package:app/domain/entities/producer.dart';
import 'package:app/domain/entities/product.dart';
import 'package:app/domain/usecases/get_origin_lot.dart';
import 'package:app/domain/usecases/get_producer_by_id.dart';
import 'package:app/domain/usecases/get_product_by_id.dart';
import 'package:app/presentation/product_detail/controllers/product_detail_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

({
  ProductDetailController controller,
  FakeProducerRepository producerRepo,
  FakeOriginLotRepository lotRepo,
}) _build({
  Result<Product>? productResult,
  Result<Producer>? producerResult,
  Result<OriginLot>? lotResult,
  String productId = 'prd_1',
}) {
  final productRepo = FakeProductRepository()
    ..getProductByIdResult = productResult ?? success(Samples.product());
  final producerRepo = FakeProducerRepository()
    ..getProducerByIdResult = producerResult ?? success(Samples.producer());
  final lotRepo = FakeOriginLotRepository()
    ..result = lotResult ?? success(Samples.originLot());

  return (
    controller: ProductDetailController(
      GetProductById(productRepo),
      GetProducerById(producerRepo),
      GetOriginLot(lotRepo),
      productId: productId,
    ),
    producerRepo: producerRepo,
    lotRepo: lotRepo,
  );
}

void main() {
  group('ProductDetailController.load', () {
    test('loads product, producer and origin lot on success', () async {
      final f = _build();

      await f.controller.load();

      expect(f.controller.status, DetailStatus.loaded);
      expect(f.controller.product?.id, 'prd_1');
      expect(f.controller.producer?.id, 'prod_1');
      expect(f.controller.hasTraceability, isTrue);
      // The product's originLotId ("lot_prd_1") is forwarded to the use case.
      expect(f.lotRepo.lastId, 'lot_prd_1');
    });

    test('errors when the product cannot be loaded', () async {
      final f = _build(productResult: failure(const NotFoundFailure()));

      await f.controller.load();

      expect(f.controller.status, DetailStatus.error);
      expect(f.controller.errorMessage, isNotEmpty);
      expect(f.controller.product, isNull);
    });

    test('still loads (degraded) when producer/lot fail', () async {
      final f = _build(
        producerResult: failure(const NetworkFailure()),
        lotResult: failure(const NotFoundFailure()),
      );

      await f.controller.load();

      expect(f.controller.status, DetailStatus.loaded);
      expect(f.controller.product?.id, 'prd_1');
      expect(f.controller.producer, isNull);
      expect(f.controller.hasTraceability, isFalse);
    });
  });
}
