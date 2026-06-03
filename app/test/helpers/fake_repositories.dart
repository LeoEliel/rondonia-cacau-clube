import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/enums.dart';
import 'package:app/domain/entities/producer.dart';
import 'package:app/domain/entities/product.dart';
import 'package:app/domain/entities/product_query.dart';
import 'package:app/domain/entities/origin_lot.dart';
import 'package:app/domain/entities/review.dart';
import 'package:app/domain/entities/subscription.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/repositories/origin_lot_repository.dart';
import 'package:app/domain/repositories/producer_repository.dart';
import 'package:app/domain/repositories/product_repository.dart';
import 'package:app/domain/repositories/review_repository.dart';
import 'package:app/domain/repositories/subscription_repository.dart';
import 'package:app/domain/repositories/user_repository.dart';

/// Hand-written fake repositories (no mocking framework). Each returns a
/// configurable [Result] and records the last arguments it received, so use
/// cases can be tested for both forwarding behavior and success/failure paths.

class FakeProductRepository implements ProductRepository {
  Result<List<Product>> getProductsResult = success(const []);
  Result<Product> getProductByIdResult = failure(const NotFoundFailure());
  Result<List<Product>> byProducerResult = success(const []);

  ProductQuery? lastQuery;
  String? lastId;
  String? lastProducerId;

  @override
  Future<Result<List<Product>>> getProducts(ProductQuery query) async {
    lastQuery = query;
    return getProductsResult;
  }

  @override
  Future<Result<Product>> getProductById(String id) async {
    lastId = id;
    return getProductByIdResult;
  }

  @override
  Future<Result<List<Product>>> getProductsByProducer(String producerId) async {
    lastProducerId = producerId;
    return byProducerResult;
  }
}

class FakeProducerRepository implements ProducerRepository {
  Result<List<Producer>> getProducersResult = success(const []);
  Result<Producer> getProducerByIdResult = failure(const NotFoundFailure());
  String? lastId;

  @override
  Future<Result<List<Producer>>> getProducers() async => getProducersResult;

  @override
  Future<Result<Producer>> getProducerById(String id) async {
    lastId = id;
    return getProducerByIdResult;
  }
}

class FakeOriginLotRepository implements OriginLotRepository {
  Result<OriginLot> result = failure(const NotFoundFailure());
  String? lastId;

  @override
  Future<Result<OriginLot>> getOriginLotById(String id) async {
    lastId = id;
    return result;
  }
}

class FakeReviewRepository implements ReviewRepository {
  Result<List<Review>> reviewsResult = success(const []);
  Result<Review> addResult = failure(const ServerFailure());
  Review? lastAdded;
  String? lastProductId;

  @override
  Future<Result<List<Review>>> getReviewsByProduct(String productId) async {
    lastProductId = productId;
    return reviewsResult;
  }

  @override
  Future<Result<Review>> addReview(Review review) async {
    lastAdded = review;
    return addResult;
  }
}

class FakeUserRepository implements UserRepository {
  Result<User> userResult = failure(const NotFoundFailure());
  Result<Unit> followResult = success(unit);
  Result<Unit> unfollowResult = success(unit);
  String? lastFollowUid;
  String? lastFollowProducerId;
  String? lastUnfollowProducerId;

  @override
  Future<Result<User>> getUserById(String uid) async => userResult;

  @override
  Future<Result<Unit>> followProducer({
    required String uid,
    required String producerId,
  }) async {
    lastFollowUid = uid;
    lastFollowProducerId = producerId;
    return followResult;
  }

  @override
  Future<Result<Unit>> unfollowProducer({
    required String uid,
    required String producerId,
  }) async {
    lastUnfollowProducerId = producerId;
    return unfollowResult;
  }
}

class FakeSubscriptionRepository implements SubscriptionRepository {
  Result<Subscription?> getResult = success(null);
  Result<Subscription> setResult = failure(const ServerFailure());
  String? lastUserId;
  SubscriptionTier? lastTier;

  @override
  Future<Result<Subscription?>> getSubscription(String userId) async {
    lastUserId = userId;
    return getResult;
  }

  @override
  Future<Result<Subscription>> setSubscriptionTier({
    required String userId,
    required SubscriptionTier tier,
  }) async {
    lastUserId = userId;
    lastTier = tier;
    return setResult;
  }
}
