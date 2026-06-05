import 'package:app/data/repositories/in_memory_subscription_repository.dart';
import 'package:app/data/repositories/revenuecat_purchases_repository.dart';
import 'package:app/data/repositories/tier_purchases_repository.dart';
import 'package:app/domain/core/result.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unwraps a [Result], failing the test if it is a [Failure].
T _value<T>(Result<T> result) =>
    result.fold((f) => fail('expected success, got: ${f.message}'), (v) => v);

void main() {
  group('TierPurchasesRepository (demo/web premium-unlock path)', () {
    late TierPurchasesRepository repo;

    setUp(() => repo = TierPurchasesRepository(InMemorySubscriptionRepository()));

    test('reports premium for the seeded paid member (Ana)', () async {
      // mock_data seeds user_ana with a paid subscription.
      expect(_value(await repo.isPremium(userId: 'user_ana')), isTrue);
    });

    test('a fresh user starts non-premium', () async {
      expect(_value(await repo.isPremium(userId: 'user_new')), isFalse);
    });

    test('purchase flips the user to premium, and it persists', () async {
      const uid = 'user_new';
      expect(_value(await repo.isPremium(userId: uid)), isFalse);

      final unlocked = _value(
        await repo.purchase(
          userId: uid,
          package: TierPurchasesRepository.premiumPackage,
        ),
      );

      expect(unlocked, isTrue);
      expect(_value(await repo.isPremium(userId: uid)), isTrue);
    });

    test('restore reflects current state — false before, true after a buy',
        () async {
      const uid = 'user_new';
      expect(_value(await repo.restorePurchases(userId: uid)), isFalse);

      await repo.purchase(
        userId: uid,
        package: TierPurchasesRepository.premiumPackage,
      );

      expect(_value(await repo.restorePurchases(userId: uid)), isTrue);
    });

    test('offers the single premium package', () async {
      final packages = _value(await repo.getOfferings());
      expect(packages, hasLength(1));
      expect(packages.single.id, 'premium');
    });
  });

  group('RevenueCat premium-unlock rule (isPremiumEntitlementActive)', () {
    test('premium when the entitlement is among the active keys', () {
      expect(isPremiumEntitlementActive(['premium'], 'premium'), isTrue);
      expect(
        isPremiumEntitlementActive(['other', 'premium'], 'premium'),
        isTrue,
      );
    });

    test('not premium when the entitlement is absent or none are active', () {
      expect(isPremiumEntitlementActive(['other'], 'premium'), isFalse);
      expect(isPremiumEntitlementActive(const [], 'premium'), isFalse);
    });
  });
}
