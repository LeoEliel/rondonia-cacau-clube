import 'package:get/get.dart';

import '../../../domain/entities/origin_lot.dart';
import '../../../domain/entities/producer.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_origin_lot.dart';
import '../../../domain/usecases/get_producer_by_id.dart';
import '../../../domain/usecases/get_product_by_id.dart';

enum DetailStatus { loading, loaded, error }

/// View-model for the Product Detail screen.
///
/// Loads the product (by the id passed as the route argument), then its
/// producer/cooperative and traceability lot through use cases. The product is
/// the only hard dependency: if the producer or origin lot fail to load the
/// screen still renders what it has (those sections degrade gracefully) rather
/// than failing the whole page.
class ProductDetailController extends GetxController {
  ProductDetailController(
    this._getProductById,
    this._getProducerById,
    this._getOriginLot, {
    required this.productId,
  });

  final GetProductById _getProductById;
  final GetProducerById _getProducerById;
  final GetOriginLot _getOriginLot;

  /// Id of the product to display (route argument).
  final String productId;

  final Rx<DetailStatus> _status = DetailStatus.loading.obs;
  final Rxn<Product> _product = Rxn<Product>();
  final Rxn<Producer> _producer = Rxn<Producer>();
  final Rxn<OriginLot> _originLot = Rxn<OriginLot>();
  final RxString _error = ''.obs;

  DetailStatus get status => _status.value;
  Product? get product => _product.value;
  Producer? get producer => _producer.value;
  OriginLot? get originLot => _originLot.value;
  String get errorMessage => _error.value;

  bool get hasTraceability => _originLot.value != null;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _status.value = DetailStatus.loading;

    // No id (e.g. a web refresh / deep link that lost its route args) → show a
    // friendly not-found state instead of querying Firestore with an empty id.
    if (productId.isEmpty) {
      _error.value = 'Produto não encontrado.';
      _status.value = DetailStatus.error;
      return;
    }

    final productResult = await _getProductById(productId);
    final product = productResult.fold<Product?>(
      (failure) {
        _error.value = failure.message;
        return null;
      },
      (value) => value,
    );
    if (product == null) {
      _status.value = DetailStatus.error;
      return;
    }
    _product.value = product;

    // Producer + origin lot are best-effort: a failure here leaves the
    // corresponding section hidden but keeps the product on screen.
    final producerResult = await _getProducerById(product.producerId);
    _producer.value = producerResult.fold((_) => null, (value) => value);

    final lotId = product.originLotId;
    if (lotId != null) {
      final lotResult = await _getOriginLot(lotId);
      _originLot.value = lotResult.fold((_) => null, (value) => value);
    } else {
      _originLot.value = null;
    }

    _status.value = DetailStatus.loaded;
  }
}
