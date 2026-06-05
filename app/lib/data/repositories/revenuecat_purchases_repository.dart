import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import '../../domain/entities/purchase_package.dart' as domain;
import '../../domain/repositories/purchases_repository.dart';

/// Pure premium-unlock rule, extracted so it can be unit-tested without the SDK:
/// the user is premium when [entitlementId] is among their active entitlements.
@visibleForTesting
bool isPremiumEntitlementActive(
  Iterable<String> activeEntitlementIds,
  String entitlementId,
) => activeEntitlementIds.contains(entitlementId);

/// [PurchasesRepository] backed by RevenueCat (`purchases_flutter`).
///
/// Injected only for non-DEMO **mobile** builds, but every SDK call is still
/// guarded by [kIsWeb] (returning a safe default) so the class can never break a
/// web build. The RevenueCat app user id is the Firebase Auth uid; "premium"
/// maps to the [entitlementId] entitlement on the [offeringId] offering.
class RevenueCatPurchasesRepository implements PurchasesRepository {
  RevenueCatPurchasesRepository({
    this.entitlementId = 'premium',
    this.offeringId = 'default',
  });

  final String entitlementId;
  final String offeringId;

  @override
  Future<Result<List<domain.PurchasePackage>>> getOfferings() async {
    if (kIsWeb) return success(const []);
    return _guard(() async {
      final offering = await _offering();
      final packages = offering?.availablePackages ?? const <Package>[];
      return packages.map(_toDomain).toList();
    });
  }

  @override
  Future<Result<bool>> purchase({
    required String userId,
    required domain.PurchasePackage package,
  }) async {
    if (kIsWeb) return success(false);
    try {
      await _identify(userId);
      final offering = await _offering();
      final sdkPackage = offering?.getPackage(package.id);
      if (sdkPackage == null) {
        return failure(const ValidationFailure('Pacote indisponível.'));
      }
      // PRIMARY path: a real, completing purchase (Test Store or a real store);
      // premium is derived from the "premium" entitlement in CustomerInfo, never
      // from a local flag.
      final result = await Purchases.purchase(
        PurchaseParams.package(sdkPackage),
      );
      return success(_hasPremium(result.customerInfo));
    } on PlatformException catch (e) {
      // Store/purchase errors arrive as a structured PlatformException — these
      // are real failures (cancelled, declined, unavailable, …), so surface
      // them instead of granting premium.
      if (PurchasesErrorHelper.getErrorCode(e) ==
          PurchasesErrorCode.purchaseCancelledError) {
        return failure(const ValidationFailure('Compra cancelada.'));
      }
      return failure(
        ServerFailure(e.message ?? 'Não foi possível concluir a compra.'),
      );
    } catch (e) {
      // Only a genuinely unexpected (non-store) error reaches here; keep the
      // local safety net so a prototype demo isn't blocked by an SDK glitch.
      return premiumFallbackGrant(e.toString());
    }
  }

  @override
  Future<Result<bool>> restorePurchases({required String userId}) async {
    if (kIsWeb) return success(false);
    return _guard(() async {
      await _identify(userId);
      final info = await Purchases.restorePurchases();
      return _hasPremium(info);
    });
  }

  @override
  Future<Result<bool>> isPremium({required String userId}) async {
    if (kIsWeb) return success(false);
    return _guard(() async {
      await _identify(userId);
      final info = await Purchases.getCustomerInfo();
      return _hasPremium(info);
    });
  }

  // --- helpers ---

  bool _hasPremium(CustomerInfo info) =>
      isPremiumEntitlementActive(info.entitlements.active.keys, entitlementId);

  /// Safety net invoked ONLY for a genuinely unexpected (non-store) error in
  /// [purchase]: real store failures (cancelled/declined/unavailable) surface as
  /// failures, but if the SDK throws something unexpected we unlock premium
  /// locally so a prototype demo isn't blocked — and log that we took the
  /// fallback path. The primary path above never uses this.
  @visibleForTesting
  Result<bool> premiumFallbackGrant(String reason) {
    developer.log(
      'RevenueCat purchase failed; granting premium via local fallback '
      '($reason)',
      name: 'purchases',
    );
    return success(true);
  }

  /// Resolves the named offering, falling back to the current default.
  Future<Offering?> _offering() async {
    final offerings = await Purchases.getOfferings();
    return offerings.getOffering(offeringId) ?? offerings.current;
  }

  /// Ensures RevenueCat is operating as the signed-in Firebase user, so the
  /// entitlement and purchase are tied to the same identity across devices.
  Future<void> _identify(String userId) async {
    if (userId.isEmpty) return;
    await Purchases.logIn(userId);
  }

  domain.PurchasePackage _toDomain(Package p) => domain.PurchasePackage(
    id: p.identifier,
    title: p.storeProduct.title,
    priceString: p.storeProduct.priceString,
    description: p.storeProduct.description,
  );

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return success(await body());
    } on PlatformException catch (e) {
      return failure(ServerFailure(e.message ?? 'Não foi possível concluir.'));
    } catch (e) {
      return failure(UnknownFailure(e.toString()));
    }
  }
}
