import '../../domain/core/result.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../mappers/subscription_mapper.dart';
import '../../seed/mock_data.dart';

/// Offline [SubscriptionRepository] backed by [MockData] (demo mode).
///
/// Keeps a mutable per-user record so a mock "Assinar o Clube" tap persists for
/// the lifetime of the session, mirroring the Firestore implementation's
/// read-after-write behavior without a backend.
class InMemorySubscriptionRepository implements SubscriptionRepository {
  InMemorySubscriptionRepository() {
    const mapper = SubscriptionMapper();
    for (final dto in MockData.subscriptions) {
      _byUser[dto.userId] = mapper.toEntity(dto);
    }
  }

  final Map<String, Subscription> _byUser = {};

  @override
  Future<Result<Subscription?>> getSubscription(String userId) async {
    return success(_byUser[userId]);
  }

  @override
  Future<Result<Subscription>> setSubscriptionTier({
    required String userId,
    required SubscriptionTier tier,
  }) async {
    final now = DateTime.now();
    final isPaid = tier == SubscriptionTier.paid;
    final subscription = Subscription(
      userId: userId,
      tier: tier,
      status: SubscriptionStatus.active,
      startedAt: _byUser[userId]?.startedAt ?? now,
      renewsAt: isPaid ? now.add(const Duration(days: 30)) : null,
    );
    _byUser[userId] = subscription;
    return success(subscription);
  }
}
