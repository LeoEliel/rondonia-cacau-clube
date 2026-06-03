import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/enums.dart';
import 'package:app/domain/entities/geo_location.dart';
import 'package:app/domain/entities/producer.dart';
import 'package:app/domain/entities/product.dart';
import 'package:app/domain/usecases/get_producers.dart';
import 'package:app/domain/usecases/get_products.dart';
import 'package:app/presentation/search/controllers/search_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

Product _product(
  String id, {
  String producerId = 'prod_1',
  ByproductCategory category = ByproductCategory.cocoaHoney,
  double rating = 4.5,
  List<QualitySeal> seals = const [QualitySeal.cacauFino],
}) =>
    Product(
      id: id,
      producerId: producerId,
      name: 'Produto $id',
      byproductCategory: category,
      description: 'desc',
      qualitySeals: seals,
      rating: rating,
      createdAt: DateTime(2026, 5, 1),
    );

({
  SearchTabController controller,
  FakeProductRepository productRepo,
}) _build({
  Result<List<Product>>? products,
  Result<List<Producer>>? producers,
}) {
  final productRepo = FakeProductRepository()
    ..getProductsResult = products ?? success(const []);
  final producerRepo = FakeProducerRepository()
    ..getProducersResult = producers ??
        success([
          Samples.producer(),
          Samples.producer(id: 'prod_2'),
        ]);
  return (
    controller: SearchTabController(
      GetProducts(productRepo),
      GetProducers(producerRepo),
    ),
    productRepo: productRepo,
  );
}

void main() {
  group('SearchTabController.load', () {
    test('loads results and derives municipality options', () async {
      final f = _build(
        products: success([_product('a'), _product('b')]),
        producers: success([
          Samples.producer(),
          const Producer(
            id: 'prod_2',
            name: 'Outra',
            type: ProducerType.cooperative,
            bio: '',
            story: '',
            municipality: 'Ariquemes',
            geo: GeoLocation(latitude: 0, longitude: 0),
          ),
        ]),
      );

      await f.controller.load();

      expect(f.controller.status, SearchStatus.loaded);
      expect(f.controller.resultCount, 2);
      // Sorted, de-duplicated municipalities from the producers.
      expect(f.controller.municipalities, ['Ariquemes', 'Ji-Paraná']);
    });

    test('sets error status when products fail', () async {
      final f = _build(products: failure(const ServerFailure()));

      await f.controller.load();

      expect(f.controller.status, SearchStatus.error);
      expect(f.controller.errorMessage, isNotEmpty);
    });
  });

  group('SearchTabController filters', () {
    test('text/category/seals/sort are forwarded via ProductQuery', () async {
      final f = _build(products: success([_product('a')]));
      await f.controller.load();

      f.controller.setText('  mel  ');
      f.controller.selectCategory(ByproductCategory.nibs);
      f.controller.toggleSeal(QualitySeal.organico);
      await f.controller.search();

      final q = f.productRepo.lastQuery!;
      expect(q.text, 'mel'); // trimmed
      expect(q.category, ByproductCategory.nibs);
      expect(q.seals, [QualitySeal.organico]);
      expect(q.sort, ProductSort.topRated); // default
    });

    test('minimum rating filters client-side', () async {
      final f = _build(products: success([
        _product('hi', rating: 4.8),
        _product('lo', rating: 4.0),
      ]));
      await f.controller.load();

      f.controller.setMinRating(4.5);
      await f.controller.search();

      expect(f.controller.results.map((p) => p.id), ['hi']);
      expect(f.controller.activeFilterCount, 1);
    });

    test('municipality filters client-side via the producer map', () async {
      final f = _build(
        products: success([
          _product('here', producerId: 'prod_1'),
          _product('there', producerId: 'prod_2'),
        ]),
        producers: success([
          Samples.producer(), // prod_1 → Ji-Paraná
          const Producer(
            id: 'prod_2',
            name: 'Outra',
            type: ProducerType.producer,
            bio: '',
            story: '',
            municipality: 'Cacoal',
            geo: GeoLocation(latitude: 0, longitude: 0),
          ),
        ]),
      );
      await f.controller.load();

      f.controller.selectMunicipality('Cacoal');
      await f.controller.search();

      expect(f.controller.results.map((p) => p.id), ['there']);
    });

    test('clearFilters resets everything but the text', () async {
      final f = _build(products: success([_product('a')]));
      await f.controller.load();

      f.controller.setText('mel');
      f.controller.selectCategory(ByproductCategory.cocoaHoney);
      f.controller.setMinRating(4.5);
      await f.controller.search();
      expect(f.controller.activeFilterCount, 2);

      f.controller.clearFilters();
      await f.controller.search();

      expect(f.controller.activeFilterCount, 0);
      expect(f.controller.text, 'mel');
    });

    test('cycleSort advances through the sort options', () async {
      final f = _build(products: success([_product('a')]));
      await f.controller.load();

      expect(f.controller.sort, ProductSort.topRated);
      f.controller.cycleSort();
      expect(f.controller.sort, ProductSort.nameAsc);
    });
  });
}
