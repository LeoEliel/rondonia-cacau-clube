import '../core/result.dart';
import '../entities/enums.dart';
import '../entities/subscription.dart';

/// Read + write access to Cocoa Club subscriptions (paid state mocked).
abstract interface class SubscriptionRepository {
  /// Current subscription for a user, or `null` if none exists yet.
  Future<Result<Subscription?>> getSubscription(String userId);

  /// Sets the user's tier and returns the resulting subscription record.
  Future<Result<Subscription>> setSubscriptionTier({
    required String userId,
    required SubscriptionTier tier,
  });
}
