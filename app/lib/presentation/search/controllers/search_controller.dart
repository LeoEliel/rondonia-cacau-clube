import 'package:get/get.dart';

import '../../../domain/core/usecase.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/producer.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/product_query.dart';
import '../../../domain/usecases/get_producers.dart';
import '../../../domain/usecases/get_products.dart';

enum SearchStatus { loading, loaded, error }

/// View-model for the Search & Filters tab.
///
/// Named `SearchTabController` (not `SearchController`) to avoid colliding with
/// Flutter Material's own `SearchController`.
///
/// Text, category, seals and sort are pushed through [ProductQuery] to the
/// [GetProducts] use case (exercising the repository's server-side filtering).
/// Municipality and minimum-rating are applied client-side afterwards, since a
/// product carries no municipality (it lives on the producer) and the catalog
/// is small enough that post-filtering is instant. Every filter change re-runs
/// the search, so the filter sheet's "Ver N resultados" count stays live.
class SearchTabController extends GetxController {
  SearchTabController(this._getProducts, this._getProducers);

  final GetProducts _getProducts;
  final GetProducers _getProducers;

  /// Minimum-rating filter options (★+ thresholds); `0` means "Qualquer".
  static const List<double> ratingOptions = [4.5, 4.0, 0.0];

  final Rx<SearchStatus> _status = SearchStatus.loading.obs;
  final RxString _error = ''.obs;
  final RxList<Product> _results = <Product>[].obs;

  // --- Filter state ---
  final RxString _text = ''.obs;
  final Rxn<ByproductCategory> _category = Rxn<ByproductCategory>();
  final RxList<QualitySeal> _seals = <QualitySeal>[].obs;
  final RxnString _municipality = RxnString();
  final RxDouble _minRating = 0.0.obs;
  final Rx<ProductSort> _sort = ProductSort.topRated.obs;

  final Map<String, Producer> _producersById = {};
  final RxList<String> _municipalities = <String>[].obs;

  SearchStatus get status => _status.value;
  String get errorMessage => _error.value;
  List<Product> get results => _results;
  int get resultCount => _results.length;

  String get text => _text.value;
  ByproductCategory? get category => _category.value;
  List<QualitySeal> get seals => _seals;
  String? get municipality => _municipality.value;
  double get minRating => _minRating.value;
  ProductSort get sort => _sort.value;
  List<String> get municipalities => _municipalities;

  /// Number of active filters (text excluded — it has its own field).
  int get activeFilterCount =>
      (_category.value != null ? 1 : 0) +
      _seals.length +
      (_municipality.value != null ? 1 : 0) +
      (_minRating.value > 0 ? 1 : 0);

  bool get hasActiveFilters => activeFilterCount > 0;

  String municipalityFor(String producerId) =>
      _producersById[producerId]?.municipality ?? '';

  /// Label for a minimum-rating option, e.g. `4.5★+`, `4★+`, `Qualquer`.
  String ratingLabel(double rating) {
    if (rating <= 0) return 'Qualquer';
    final n = rating == rating.truncateToDouble()
        ? rating.toInt().toString()
        : rating.toString();
    return '$n★+';
  }

  @override
  void onInit() {
    super.onInit();
    // Debounce free-text so typing doesn't fire a query per keystroke.
    debounce<String>(_text, (_) => search(),
        time: const Duration(milliseconds: 350));
    load();
  }

  /// Loads the producer index (for municipality options + mapping) and runs the
  /// initial search.
  Future<void> load() async {
    _status.value = SearchStatus.loading;
    final producersResult = await _getProducers(const NoParams());
    producersResult.fold(
      (failure) => _error.value = failure.message,
      (producers) {
        _producersById
          ..clear()
          ..addEntries(producers.map((p) => MapEntry(p.id, p)));
        _municipalities.assignAll(
          producers.map((p) => p.municipality).toSet().toList()..sort(),
        );
      },
    );
    await search();
  }

  Future<void> search() async {
    _status.value = SearchStatus.loading;

    final query = ProductQuery(
      text: _text.value.trim().isEmpty ? null : _text.value.trim(),
      category: _category.value,
      seals: _seals.toList(),
      sort: _sort.value,
    );

    final result = await _getProducts(query);
    result.fold(
      (failure) {
        _error.value = failure.message;
        _status.value = SearchStatus.error;
      },
      (products) {
        _results.assignAll(_applyClientFilters(products));
        _status.value = SearchStatus.loaded;
      },
    );
  }

  /// Applies the filters not expressed by [ProductQuery] (municipality lives on
  /// the producer; minimum rating is a simple threshold).
  List<Product> _applyClientFilters(List<Product> products) {
    final municipality = _municipality.value;
    final minRating = _minRating.value;
    return products.where((p) {
      if (minRating > 0 && p.rating < minRating) return false;
      if (municipality != null &&
          municipalityFor(p.producerId) != municipality) {
        return false;
      }
      return true;
    }).toList();
  }

  // --- Filter mutations (each re-runs the search) ---

  void setText(String value) => _text.value = value;

  void clearText() {
    _text.value = '';
    search();
  }

  void selectCategory(ByproductCategory? category) {
    _category.value = _category.value == category ? null : category;
    search();
  }

  void toggleSeal(QualitySeal seal) {
    if (_seals.contains(seal)) {
      _seals.remove(seal);
    } else {
      _seals.add(seal);
    }
    search();
  }

  void selectMunicipality(String? municipality) {
    _municipality.value =
        _municipality.value == municipality ? null : municipality;
    search();
  }

  void setMinRating(double rating) {
    _minRating.value = rating;
    search();
  }

  void setSort(ProductSort sort) {
    _sort.value = sort;
    search();
  }

  /// Cycles through the sort options (the results header acts as the control).
  void cycleSort() {
    const order = ProductSort.values;
    final next = order[(order.indexOf(_sort.value) + 1) % order.length];
    setSort(next);
  }

  /// Clears every filter (but keeps the typed text).
  void clearFilters() {
    _category.value = null;
    _seals.clear();
    _municipality.value = null;
    _minRating.value = 0;
    search();
  }
}
