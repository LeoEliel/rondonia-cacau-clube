import 'package:app/data/repositories/in_memory_subscription_repository.dart';
import 'package:app/data/repositories/revenuecat_purchases_repository.dart';
import 'package:app/data/repositories/tier_purchases_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RevenueCatPurchasesRepository premium-unlock logic', () {
    // The PRIMARY path derives premium from the "premium" entitlement.
    test('entitlement-active rule reads the active entitlements', () {
      expect(
        isPremiumEntitlementActive(const ['premium'], 'premium'),
        isTrue,
      );
      expect(
        isPremiumEntitlementActive(const ['some_other'], 'premium'),
        isFalse,
      );
      expect(isPremiumEntitlementActive(const [], 'premium'), isFalse);
    });

    // The catch-only safety net: unlock premium locally when the SDK throws.
    test('catch fallback unlocks premium locally', () {
      final repo = RevenueCatPurchasesRepository();
      final result = repo.premiumFallbackGrant('boom');
      expect(result.getOrElse(() => false), isTrue);
    });
  });

  group('TierPurchasesRepository (DEMO flag flip)', () {
    test('buying flips the user to premium; restoring/isPremium reflect it',
        () async {
      final repo = TierPurchasesRepository(InMemorySubscriptionRepository());
      const uid = 'user_new'; // not seeded → starts non-premium

      expect((await repo.isPremium(userId: uid)).getOrElse(() => true), isFalse);

      final bought = await repo.purchase(
        userId: uid,
        package: TierPurchasesRepository.premiumPackage,
      );
      expect(bought.getOrElse(() => false), isTrue);

      expect(
        (await repo.isPremium(userId: uid)).getOrElse(() => false),
        isTrue,
      );
      expect(
        (await repo.restorePurchases(userId: uid)).getOrElse(() => false),
        isTrue,
      );
    });

    test('exposes a single synthetic premium package', () async {
      final repo = TierPurchasesRepository(InMemorySubscriptionRepository());
      final offerings = await repo.getOfferings();
      final packages = offerings.getOrElse(() => const []);
      expect(packages, hasLength(1));
      expect(packages.first.id, 'premium');
    });
  });
}
