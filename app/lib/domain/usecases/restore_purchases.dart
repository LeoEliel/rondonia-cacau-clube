import '../core/result.dart';
import '../core/usecase.dart';
import '../repositories/purchases_repository.dart';

/// Restores a user's prior purchases (e.g. after reinstall / new device),
/// resolving to the resulting premium state. Params is the user id.
class RestorePurchases implements UseCase<bool, String> {
  const RestorePurchases(this._repository);

  final PurchasesRepository _repository;

  @override
  Future<Result<bool>> call(String userId) =>
      _repository.restorePurchases(userId: userId);
}
