import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/datasources/origin_lot_remote_data_source.dart';
import '../../data/datasources/producer_remote_data_source.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/datasources/review_remote_data_source.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/demo_auth_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/in_memory_origin_lot_repository.dart';
import '../../data/repositories/in_memory_producer_repository.dart';
import '../../data/repositories/in_memory_product_repository.dart';
import '../../data/repositories/in_memory_review_repository.dart';
import '../../data/repositories/in_memory_subscription_repository.dart';
import '../../data/repositories/in_memory_user_repository.dart';
import '../../data/repositories/origin_lot_repository_impl.dart';
import '../../data/repositories/producer_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/origin_lot_repository.dart';
import '../../domain/repositories/producer_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/add_review.dart';
import '../../domain/usecases/follow_producer.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/get_origin_lot.dart';
import '../../domain/usecases/get_producer_by_id.dart';
import '../../domain/usecases/get_producers.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/get_product_reviews.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_producer.dart';
import '../../domain/usecases/get_subscription.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/set_subscription_tier.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import '../../domain/usecases/unfollow_producer.dart';

/// Wires the data graph: Firestore → data sources → repository implementations
/// (bound to their domain interfaces) → use cases.
///
/// Everything is `lazyPut` with `fenix: true` (stateless singletons recreated
/// on demand). Repositories are registered against their **interface** types so
/// use cases and controllers depend only on abstractions (Dependency
/// Inversion); swapping Firestore for another backend touches this file alone.
class DataBinding extends Bindings {
  /// Toggled with `--dart-define=DEMO=true` to run against in-memory mock data.
  static const bool _demoMode = bool.fromEnvironment('DEMO');

  @override
  void dependencies() {
    // --- Firebase ---
    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
      fenix: true,
    );

    // --- Data sources ---
    Get.lazyPut(() => ProductRemoteDataSource(Get.find()), fenix: true);
    Get.lazyPut(() => ProducerRemoteDataSource(Get.find()), fenix: true);
    Get.lazyPut(() => OriginLotRemoteDataSource(Get.find()), fenix: true);
    Get.lazyPut(() => ReviewRemoteDataSource(Get.find()), fenix: true);
    Get.lazyPut(() => UserRemoteDataSource(Get.find()), fenix: true);
    Get.lazyPut(() => SubscriptionRemoteDataSource(Get.find()), fenix: true);

    // --- Repositories (interface ← implementation) ---
    // In demo mode the catalog + traceability repositories are served from
    // in-memory mock data so the UI can be explored without a seeded Firestore.
    // Everything else (and the default build) stays Firestore-backed.
    if (_demoMode) {
      Get.lazyPut<ProductRepository>(InMemoryProductRepository.new,
          fenix: true);
      Get.lazyPut<ProducerRepository>(InMemoryProducerRepository.new,
          fenix: true);
      Get.lazyPut<OriginLotRepository>(InMemoryOriginLotRepository.new,
          fenix: true);
      Get.lazyPut<ReviewRepository>(InMemoryReviewRepository.new, fenix: true);
      Get.lazyPut<UserRepository>(InMemoryUserRepository.new, fenix: true);
      Get.lazyPut<AuthRepository>(DemoAuthRepository.new, fenix: true);
      Get.lazyPut<SubscriptionRepository>(
          InMemorySubscriptionRepository.new, fenix: true);
    } else {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
        fenix: true,
      );
      Get.lazyPut<ProducerRepository>(
        () => ProducerRepositoryImpl(Get.find<ProducerRemoteDataSource>()),
        fenix: true,
      );
      Get.lazyPut<OriginLotRepository>(
        () => OriginLotRepositoryImpl(Get.find<OriginLotRemoteDataSource>()),
        fenix: true,
      );
      Get.lazyPut<ReviewRepository>(
        () => ReviewRepositoryImpl(Get.find<ReviewRemoteDataSource>()),
        fenix: true,
      );
      Get.lazyPut<UserRepository>(
        () => UserRepositoryImpl(Get.find<UserRemoteDataSource>()),
        fenix: true,
      );
      Get.lazyPut<AuthRepository>(
        () => FirebaseAuthRepository(Get.find<UserRemoteDataSource>()),
        fenix: true,
      );
      Get.lazyPut<SubscriptionRepository>(
        () =>
            SubscriptionRepositoryImpl(Get.find<SubscriptionRemoteDataSource>()),
        fenix: true,
      );
    }

    // --- Use cases ---
    Get.lazyPut(() => GetProducts(Get.find()), fenix: true);
    Get.lazyPut(() => GetProductById(Get.find()), fenix: true);
    Get.lazyPut(() => GetProductsByProducer(Get.find()), fenix: true);
    Get.lazyPut(() => GetProducers(Get.find()), fenix: true);
    Get.lazyPut(() => GetProducerById(Get.find()), fenix: true);
    Get.lazyPut(() => GetOriginLot(Get.find()), fenix: true);
    Get.lazyPut(() => GetProductReviews(Get.find()), fenix: true);
    Get.lazyPut(() => AddReview(Get.find()), fenix: true);
    Get.lazyPut(() => GetUser(Get.find()), fenix: true);
    Get.lazyPut(() => FollowProducer(Get.find()), fenix: true);
    Get.lazyPut(() => UnfollowProducer(Get.find()), fenix: true);
    Get.lazyPut(() => GetSubscription(Get.find()), fenix: true);
    Get.lazyPut(() => SetSubscriptionTier(Get.find()), fenix: true);
    Get.lazyPut(() => GetCurrentUser(Get.find()), fenix: true);
    Get.lazyPut(() => SignInWithEmail(Get.find()), fenix: true);
    Get.lazyPut(() => SignUpWithEmail(Get.find()), fenix: true);
    Get.lazyPut(() => SignInWithGoogle(Get.find()), fenix: true);
    Get.lazyPut(() => SignOut(Get.find()), fenix: true);
  }
}
