import '../../domain/core/result.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../core/firestore_guard.dart';
import '../datasources/subscription_remote_data_source.dart';
import '../mappers/subscription_mapper.dart';

/// [SubscriptionRepository] backed by Firestore. Paid state is mocked: setting
/// the paid tier simply activates the record and schedules a 30-day renewal.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._ds);

  final SubscriptionRemoteDataSource _ds;
  final SubscriptionMapper _mapper = const SubscriptionMapper();

  @override
  Future<Result<Subscription?>> getSubscription(String userId) {
    return guardFirestore(() async {
      final dto = await _ds.fetch(userId);
      return dto == null ? null : _mapper.toEntity(dto);
    });
  }

  @override
  Future<Result<Subscription>> setSubscriptionTier({
    required String userId,
    required SubscriptionTier tier,
  }) {
    return guardFirestore(() async {
      final now = DateTime.now();
      final isPaid = tier == SubscriptionTier.paid;
      final subscription = Subscription(
        userId: userId,
        tier: tier,
        status: SubscriptionStatus.active,
        startedAt: now,
        renewsAt: isPaid ? now.add(const Duration(days: 30)) : null,
      );
      await _ds.set(_mapper.toDto(subscription));
      return subscription;
    });
  }
}
