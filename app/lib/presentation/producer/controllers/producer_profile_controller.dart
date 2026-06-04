import 'package:get/get.dart';

import '../../../core/session/session_controller.dart';
import '../../../domain/entities/producer.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_producer_by_id.dart';
import '../../../domain/usecases/get_products_by_producer.dart';

enum ProducerStatus { loading, loaded, error }

/// View-model for the Producer / Cooperative profile screen.
///
/// Loads the producer (by the id passed as the route argument) plus the list of
/// products it makes. Follow state is delegated to [SessionController] so it
/// stays consistent across screens; the displayed follower count reflects the
/// current user's own follow toggle on top of the seeded aggregate.
class ProducerProfileController extends GetxController {
  ProducerProfileController(
    this._getProducerById,
    this._getProductsByProducer,
    this._session, {
    required this.producerId,
  });

  final GetProducerById _getProducerById;
  final GetProductsByProducer _getProductsByProducer;
  final SessionController _session;

  /// Id of the producer to display (route argument).
  final String producerId;

  final Rx<ProducerStatus> _status = ProducerStatus.loading.obs;
  final Rxn<Producer> _producer = Rxn<Producer>();
  final RxList<Product> _products = <Product>[].obs;
  final RxString _error = ''.obs;

  /// Whether the current user already followed this producer when the screen
  /// opened — used to offset the aggregate follower count.
  bool _initiallyFollowing = false;

  ProducerStatus get status => _status.value;
  Producer? get producer => _producer.value;
  List<Product> get products => _products;
  String get errorMessage => _error.value;

  bool get isFollowing => _session.isFollowing(producerId);

  /// Seeded follower count adjusted by the current user's own toggle so the
  /// number moves the moment they tap Follow.
  int get followerCount {
    final base = _producer.value?.followerCount ?? 0;
    final delta = (isFollowing ? 1 : 0) - (_initiallyFollowing ? 1 : 0);
    return base + delta;
  }

  int get productCount => _products.length;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _status.value = ProducerStatus.loading;

    // No id (e.g. a web refresh / deep link that lost its route args) → show a
    // friendly not-found state instead of querying Firestore with an empty id.
    if (producerId.isEmpty) {
      _error.value = 'Produtor não encontrado.';
      _status.value = ProducerStatus.error;
      return;
    }

    final producerResult = await _getProducerById(producerId);
    final producer = producerResult.fold<Producer?>(
      (failure) {
        _error.value = failure.message;
        return null;
      },
      (value) => value,
    );
    if (producer == null) {
      _status.value = ProducerStatus.error;
      return;
    }
    _producer.value = producer;
    _initiallyFollowing = _session.isFollowing(producerId);

    // Products are best-effort: an empty/failed list still renders the profile.
    final productsResult = await _getProductsByProducer(producerId);
    _products.assignAll(
      productsResult.fold((_) => const <Product>[], (value) => value),
    );

    _status.value = ProducerStatus.loaded;
  }

  Future<void> toggleFollow() => _session.toggleFollow(producerId);
}
