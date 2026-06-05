import '../core/result.dart';
import '../core/usecase.dart';
import '../repositories/purchases_repository.dart';

/// Reads whether the user currently holds the Cocoa Club premium entitlement.
/// Params is the user id.
class CheckPremium implements UseCase<bool, String> {
  const CheckPremium(this._repository);

  final PurchasesRepository _repository;

  @override
  Future<Result<bool>> call(String userId) =>
      _repository.isPremium(userId: userId);
}
