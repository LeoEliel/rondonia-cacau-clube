import 'package:app/domain/entities/enums.dart';
import 'package:app/domain/entities/geo_location.dart';
import 'package:app/domain/entities/origin_lot.dart';
import 'package:app/domain/entities/producer.dart';
import 'package:app/domain/entities/product.dart';
import 'package:app/domain/entities/review.dart';
import 'package:app/domain/entities/subscription.dart';
import 'package:app/domain/entities/user.dart';

/// Minimal sample entities for use-case tests.
abstract final class Samples {
  static final DateTime _date = DateTime(2026, 5, 1);

  static Product product({String id = 'prd_1'}) => Product(
        id: id,
        producerId: 'prod_1',
        name: 'Mel de Cacau Puro',
        byproductCategory: ByproductCategory.cocoaHoney,
        description: 'Mel de cacau de teste.',
        qualitySeals: const [QualitySeal.cacauFino],
        originLotId: 'lot_$id',
        rating: 4.9,
        reviewCount: 3,
        createdAt: _date,
      );

  static Producer producer({String id = 'prod_1'}) => Producer(
        id: id,
        name: 'Sítio Mel da Floresta',
        type: ProducerType.producer,
        bio: 'bio',
        story: 'story',
        municipality: 'Ji-Paraná',
        geo: const GeoLocation(latitude: -10.88, longitude: -61.95),
        rating: 4.9,
      );

  static OriginLot originLot({String id = 'lot_prd_1'}) => OriginLot(
        id: id,
        producerId: 'prod_1',
        municipality: 'Ji-Paraná',
        geo: const GeoLocation(latitude: -10.88, longitude: -61.95),
        harvestDate: _date,
      );

  static Review review({String id = 'rev_1', String productId = 'prd_1'}) =>
      Review(
        id: id,
        productId: productId,
        userId: 'user_ana',
        rating: 5,
        text: 'Excelente!',
        createdAt: _date,
        userName: 'Ana Souza',
      );

  static User user({String uid = 'user_ana'}) => User(
        uid: uid,
        name: 'Ana Souza',
        email: 'ana@example.com',
        subscriptionTier: SubscriptionTier.paid,
        followingProducerIds: const ['prod_1'],
        createdAt: _date,
      );

  static Subscription subscription({String userId = 'user_ana'}) => Subscription(
        userId: userId,
        tier: SubscriptionTier.paid,
        status: SubscriptionStatus.active,
        startedAt: _date,
      );
}
