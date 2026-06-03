import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

/// Fetches the user's Cocoa Club subscription (or `null` if none).
class GetSubscription implements UseCase<Subscription?, String> {
  const GetSubscription(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Result<Subscription?>> call(String params) =>
      _repository.getSubscription(params);
}
