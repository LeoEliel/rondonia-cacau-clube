import 'package:get/get.dart';

import '../../../domain/core/usecase.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/producer.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/product_query.dart';
import '../../../domain/usecases/get_producers.dart';
import '../../../domain/usecases/get_products.dart';
import '../../shell/controllers/shell_controller.dart';

enum HomeStatus { loading, loaded, error }

/// View-model for the Home / Catalog tab.
///
/// Loads the catalog (products) and producers through use cases, exposes a
/// reactive list filtered by the selected byproduct category, and derives the
/// featured hero. Category filtering is done in-memory for instant chip
/// response; the same [GetProducts] use case also supports server-side
/// filtering via [ProductQuery] (used later by the Search screen).
class HomeController extends GetxController {
  HomeController(this._getProducts, this._getProducers);

  final GetProducts _getProducts;
  final GetProducers _getProducers;

  final Rx<HomeStatus> _status = HomeStatus.loading.obs;
  final RxList<Product> _all = <Product>[].obs;
  final RxList<Product> _visible = <Product>[].obs;
  final Rxn<ByproductCategory> _selectedCategory = Rxn<ByproductCategory>();
  final Rxn<Product> _featured = Rxn<Product>();
  final RxString _error = ''.obs;

  final Map<String, Producer> _producersById = {};

  HomeStatus get status => _status.value;
  List<Product> get visibleProducts => _visible;
  ByproductCategory? get selectedCategory => _selectedCategory.value;
  Product? get featuredProduct => _featured.value;
  String get errorMessage => _error.value;

  Producer? get featuredProducer {
    final p = _featured.value;
    return p == null ? null : _producersById[p.producerId];
  }

  /// Municipality of the producer behind [producerId] (empty if unknown).
  String municipalityFor(String producerId) =>
      _producersById[producerId]?.municipality ?? '';

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _status.value = HomeStatus.loading;

    final producersResult = await _getProducers(const NoParams());
    final producers = producersResult.fold<List<Producer>?>(
      (failure) {
        _error.value = failure.message;
        return null;
      },
      (list) => list,
    );
    if (producers == null) {
      _status.value = HomeStatus.error;
      return;
    }
    _producersById
      ..clear()
      ..addEntries(producers.map((p) => MapEntry(p.id, p)));

    final productsResult = await _getProducts(
      const ProductQuery(sort: ProductSort.recent),
    );
    productsResult.fold(
      (failure) {
        _error.value = failure.message;
        _status.value = HomeStatus.error;
      },
      (products) {
        _all.assignAll(products);
        _featured.value = _pickFeatured(products);
        _applyFilter();
        _status.value = HomeStatus.loaded;
      },
    );
  }

  void selectCategory(ByproductCategory? category) {
    _selectedCategory.value = category;
    _applyFilter();
  }

  void clearCategory() => selectCategory(null);

  /// Opens the Search tab (the prominent search field is an entry point).
  void goToSearch() {
    if (Get.isRegistered<ShellController>()) {
      Get.find<ShellController>().changeTab(1);
    }
  }

  void _applyFilter() {
    final category = _selectedCategory.value;
    _visible.assignAll(
      category == null
          ? _all
          : _all.where((p) => p.byproductCategory == category),
    );
  }

  /// Featured = the curated mel de cacau hero if seeded, else the first cocoa
  /// honey product, else the first product available.
  Product? _pickFeatured(List<Product> products) {
    if (products.isEmpty) return null;
    for (final p in products) {
      if (p.id == 'prd_mel_001') return p;
    }
    for (final p in products) {
      if (p.byproductCategory == ByproductCategory.cocoaHoney) return p;
    }
    return products.first;
  }
}
