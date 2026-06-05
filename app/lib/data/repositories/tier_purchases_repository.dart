import '../../domain/core/result.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/purchase_package.dart';
import '../../domain/repositories/purchases_repository.dart';
import '../../domain/repositories/subscription_repository.dart';

/// [PurchasesRepository] backed by the existing tier [SubscriptionRepository]
/// instead of a store SDK. Used wherever RevenueCat can't run:
///   * DEMO mode — over the in-memory mock (Ana is already premium); fully
///     offline, zero secrets.
///   * the non-DEMO **web** build — over Firestore, so the Club CTA still works.
///
/// "Buying" flips the user to the paid tier; "restoring" re-reads it. The Club
/// controller + UI behave identically to the RevenueCat path — only the real
/// store price is absent.
class TierPurchasesRepository implements PurchasesRepository {
  TierPurchasesRepository(this._tier);

  final SubscriptionRepository _tier;

  /// Single synthetic package standing in for the Club premium tier (there is
  /// no real store price outside RevenueCat).
  static const PurchasePackage premiumPackage = PurchasePackage(
    id: 'premium',
    title: 'Clube Premium',
    priceString: '',
    description: 'Histórias, lançamentos antecipados e conteúdo curado.',
  );

  @override
  Future<Result<List<PurchasePackage>>> getOfferings() async =>
      success(const [premiumPackage]);

  @override
  Future<Result<bool>> purchase({
    required String userId,
    required PurchasePackage package,
  }) async {
    final result = await _tier.setSubscriptionTier(
      userId: userId,
      tier: SubscriptionTier.paid,
    );
    return result.map((subscription) => subscription.isActivePaid);
  }

  @override
  Future<Result<bool>> restorePurchases({required String userId}) =>
      isPremium(userId: userId);

  @override
  Future<Result<bool>> isPremium({required String userId}) async {
    final result = await _tier.getSubscription(userId);
    return result.map((subscription) => subscription?.isActivePaid ?? false);
  }
}
