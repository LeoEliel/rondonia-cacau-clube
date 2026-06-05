import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/purchase_package.dart';
import '../repositories/purchases_repository.dart';

/// Loads the purchasable Cocoa Club packages from the current store offering.
class GetOfferings implements UseCase<List<PurchasePackage>, NoParams> {
  const GetOfferings(this._repository);

  final PurchasesRepository _repository;

  @override
  Future<Result<List<PurchasePackage>>> call(NoParams params) =>
      _repository.getOfferings();
}
