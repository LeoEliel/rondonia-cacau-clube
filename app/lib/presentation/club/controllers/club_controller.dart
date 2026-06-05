import 'package:get/get.dart';

import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/core/usecase.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/purchase_package.dart';
import '../../../domain/usecases/check_premium.dart';
import '../../../domain/usecases/get_offerings.dart';
import '../../../domain/usecases/purchase_premium.dart';
import '../../../domain/usecases/restore_purchases.dart';
import '../models/club_content.dart';

/// View-model for the Cocoa Club tab.
///
/// Talks only to the purchase use cases (backed by `PurchasesRepository`), so it
/// is identical across modes — DEMO and non-DEMO web run the tier-backed mock,
/// non-DEMO mobile runs RevenueCat; only the injected repo differs. Premium
/// state is owned here and mirrored onto the [SessionController] so the Profile
/// tab stays in sync.
///
/// Feedback is surfaced reactively: [subscribe]/[restore] return whether the
/// user is now premium, and failures land in [errorMessage]. The page turns
/// those into snackbars so the controller stays free of UI dependencies.
class ClubController extends GetxController {
  ClubController(
    this._session,
    this._getOfferings,
    this._purchasePremium,
    this._restorePurchases,
    this._checkPremium,
  );

  final SessionController _session;
  final GetOfferings _getOfferings;
  final PurchasePremium _purchasePremium;
  final RestorePurchases _restorePurchases;
  final CheckPremium _checkPremium;

  final RxBool _premium = false.obs;
  final RxList<PurchasePackage> _packages = <PurchasePackage>[].obs;
  final RxBool _subscribing = false.obs;
  final RxBool _restoring = false.obs;
  final RxnString _error = RxnString();

  /// Whether the current user holds the Club premium entitlement (reactive).
  bool get isMember => _premium.value;

  /// Packages available to purchase (from the current store offering).
  List<PurchasePackage> get packages => _packages;

  /// The package the CTA purchases (first of the offering).
  PurchasePackage? get primaryPackage =>
      _packages.isEmpty ? null : _packages.first;

  /// Localized store price for the primary package, or `null` when unknown
  /// (the mock / web fallback has no real price).
  String? get priceLabel {
    final price = primaryPackage?.priceString ?? '';
    return price.isEmpty ? null : price;
  }

  /// Whether a subscribe request is in flight (drives the CTA spinner).
  bool get isSubscribing => _subscribing.value;

  /// Whether a restore request is in flight.
  bool get isRestoring => _restoring.value;

  /// Message from the last failed subscribe / restore attempt, or `null`.
  String? get errorMessage => _error.value;

  /// Members-only content revealed once premium (mock data).
  List<ClubContent> get exclusiveContent => const [
    ClubContent(
      title: 'A safra do mel em Ji-Paraná',
      category: 'História',
      minutes: 4,
      accent: AppColors.greenSoft,
    ),
    ClubContent(
      title: 'Nibs: do fruto à crocância',
      category: 'Receita',
      minutes: 6,
      accent: AppColors.choco600,
    ),
    ClubContent(
      title: 'Harmonização: mel de cacau & queijos',
      category: 'Harmonização',
      minutes: 5,
      accent: AppColors.caramel,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Seed from the session for an instant first paint, then confirm / refresh.
    _premium.value = _session.isClubMember;
    load();
  }

  /// Loads the store offering and confirms current premium state.
  Future<void> load() async {
    final offeringsResult = await _getOfferings(const NoParams());
    offeringsResult.fold((_) => null, _packages.assignAll);

    final uid = _session.currentUserId;
    if (uid == null) return;
    final premiumResult = await _checkPremium(uid);
    premiumResult.fold((_) => null, (premium) {
      if (premium) _grantPremium();
    });
  }

  /// Purchases the primary package, unlocking premium. Returns `true` when the
  /// user is now a member. No-op (returns `false`) when there is no signed-in
  /// user / package, they are already a member, or a request is in flight.
  Future<bool> subscribe() async {
    final uid = _session.currentUserId;
    final package = primaryPackage;
    if (uid == null || package == null || isMember || _subscribing.value) {
      return false;
    }

    _error.value = null;
    _subscribing.value = true;
    final result = await _purchasePremium(
      PurchasePremiumParams(userId: uid, package: package),
    );
    _subscribing.value = false;

    return result.fold(
      (failure) {
        _error.value = failure.message;
        return false;
      },
      (premium) {
        if (premium) _grantPremium();
        return premium;
      },
    );
  }

  /// Restores prior purchases for the signed-in user, unlocking premium when a
  /// purchase is found. Returns the resulting premium state.
  Future<bool> restore() async {
    final uid = _session.currentUserId;
    if (uid == null || _restoring.value) return false;

    _error.value = null;
    _restoring.value = true;
    final result = await _restorePurchases(uid);
    _restoring.value = false;

    return result.fold(
      (failure) {
        _error.value = failure.message;
        return false;
      },
      (premium) {
        if (premium) _grantPremium();
        return premium;
      },
    );
  }

  /// Marks the user premium locally and mirrors it onto the session (so the
  /// Profile tab updates too). Never downgrades — premium is only ever granted.
  void _grantPremium() {
    _premium.value = true;
    _session.applySubscriptionTier(SubscriptionTier.paid);
  }
}
