import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/enums.dart';
import 'package:app/domain/entities/product.dart';
import 'package:app/domain/usecases/get_producers.dart';
import 'package:app/domain/usecases/get_products.dart';
import 'package:app/presentation/home/controllers/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

Product _product(String id, ByproductCategory category) => Product(
      id: id,
      producerId: 'prod_1',
      name: 'Produto $id',
      byproductCategory: category,
      description: 'desc',
      rating: 4.5,
      createdAt: DateTime(2026, 5, 1),
    );

HomeController _controller({required Result<List<Product>> products}) {
  final productRepo = FakeProductRepository()..getProductsResult = products;
  final producerRepo = FakeProducerRepository()
    ..getProducersResult = success([Samples.producer()]);
  return HomeController(
    GetProducts(productRepo),
    GetProducers(producerRepo),
  );
}

void main() {
  group('HomeController.load', () {
    test('populates products, producer map and featured product', () async {
      final c = _controller(
        products: success([
          _product('prd_mel_001', ByproductCategory.cocoaHoney),
          _product('prd_nib_1', ByproductCategory.nibs),
        ]),
      );

      await c.load();

      expect(c.status, HomeStatus.loaded);
      expect(c.visibleProducts.length, 2);
      expect(c.featuredProduct?.id, 'prd_mel_001');
      expect(c.featuredProducer?.municipality, 'Ji-Paraná');
      expect(c.municipalityFor('prod_1'), 'Ji-Paraná');
    });

    test('sets error status when products fail to load', () async {
      final c = _controller(products: failure(const ServerFailure()));

      await c.load();

      expect(c.status, HomeStatus.error);
      expect(c.errorMessage, isNotEmpty);
    });

    test('sets error status when producers fail to load', () async {
      final productRepo = FakeProductRepository()
        ..getProductsResult = success([]);
      final producerRepo = FakeProducerRepository()
        ..getProducersResult = failure(const NetworkFailure());
      final c = HomeController(
        GetProducts(productRepo),
        GetProducers(producerRepo),
      );

      await c.load();

      expect(c.status, HomeStatus.error);
    });
  });

  group('HomeController category filtering', () {
    test('selectCategory filters and clearCategory restores', () async {
      final c = _controller(
        products: success([
          _product('a', ByproductCategory.cocoaHoney),
          _product('b', ByproductCategory.nibs),
          _product('c', ByproductCategory.cocoaHoney),
        ]),
      );
      await c.load();

      c.selectCategory(ByproductCategory.nibs);
      expect(c.selectedCategory, ByproductCategory.nibs);
      expect(c.visibleProducts.map((p) => p.id), ['b']);

      c.clearCategory();
      expect(c.selectedCategory, isNull);
      expect(c.visibleProducts.length, 3);
    });
  });
}
