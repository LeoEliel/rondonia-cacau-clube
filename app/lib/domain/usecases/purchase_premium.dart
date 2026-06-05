import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/purchase_package.dart';
import '../repositories/purchases_repository.dart';

/// Purchases a Cocoa Club [PurchasePackage], unlocking the premium entitlement.
/// Resolves to the resulting premium state (`true` when the user is now premium).
class PurchasePremium implements UseCase<bool, PurchasePremiumParams> {
  const PurchasePremium(this._repository);

  final PurchasesRepository _repository;

  @override
  Future<Result<bool>> call(PurchasePremiumParams params) =>
      _repository.purchase(userId: params.userId, package: params.package);
}

/// Input for [PurchasePremium].
class PurchasePremiumParams {
  const PurchasePremiumParams({required this.userId, required this.package});

  final String userId;
  final PurchasePackage package;
}
