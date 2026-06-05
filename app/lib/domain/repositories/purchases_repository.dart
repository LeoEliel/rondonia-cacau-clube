import '../core/result.dart';
import '../entities/purchase_package.dart';

/// In-app purchase access for the Cocoa Club premium entitlement.
///
/// Abstracts the store/billing layer (RevenueCat on mobile) behind the domain so
/// the Club controller and UI stay identical regardless of which implementation
/// is injected (real RevenueCat, the Firestore-tier web fallback, or the offline
/// demo mock — see `DataBinding`). No `purchases_flutter` types cross this
/// boundary; packages are exposed as [PurchasePackage] and entitlement state as
/// a plain `bool`.
abstract interface class PurchasesRepository {
  /// Available Club packages from the current store offering (empty when none).
  Future<Result<List<PurchasePackage>>> getOfferings();

  /// Purchases [package] for [userId]; resolves to the resulting premium state.
  Future<Result<bool>> purchase({
    required String userId,
    required PurchasePackage package,
  });

  /// Restores prior purchases for [userId]; resolves to the resulting premium
  /// state.
  Future<Result<bool>> restorePurchases({required String userId});

  /// Whether [userId] currently holds the premium ("premium") entitlement.
  Future<Result<bool>> isPremium({required String userId});
}
