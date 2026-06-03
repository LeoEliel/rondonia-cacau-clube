import 'enums.dart';

/// Cocoa Club subscription record (the `subscriptions` collection).
/// Paid state is mocked in this prototype — no real payment provider.
class Subscription {
  const Subscription({
    required this.userId,
    required this.tier,
    required this.status,
    required this.startedAt,
    this.renewsAt,
  });

  final String userId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final DateTime startedAt;
  final DateTime? renewsAt;

  bool get isActivePaid =>
      tier == SubscriptionTier.paid && status == SubscriptionStatus.active;
}
