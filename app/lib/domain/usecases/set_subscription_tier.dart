import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/enums.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

/// Changes the user's Cocoa Club tier (mock upgrade/downgrade — no real
/// payment). Backs the subscribe / manage actions on the Club screen.
class SetSubscriptionTier
    implements UseCase<Subscription, SetSubscriptionTierParams> {
  const SetSubscriptionTier(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<Subscription>> call(SetSubscriptionTierParams params) =>
      _repository.setSubscriptionTier(userId: params.userId, tier: params.tier);
}

/// Input for [SetSubscriptionTier].
class SetSubscriptionTierParams {
  const SetSubscriptionTierParams({required this.userId, required this.tier});

  final String userId;
  final SubscriptionTier tier;
}
