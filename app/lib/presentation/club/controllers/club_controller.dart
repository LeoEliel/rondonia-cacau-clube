import 'package:get/get.dart';

import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/usecases/set_subscription_tier.dart';
import '../models/club_content.dart';

/// View-model for the Cocoa Club tab.
///
/// Reads Club membership from the [SessionController] (so the screen and the
/// Profile tab stay in sync) and handles the mock "Assinar o Clube" flow via
/// [SetSubscriptionTier]. Paid state is mocked — there is no real payment.
///
/// Feedback is surfaced reactively: [subscribe] returns whether the user newly
/// became a member, and failures land in [errorMessage]. The page turns those
/// into a snackbar so the controller stays free of UI dependencies.
class ClubController extends GetxController {
  ClubController(this._session, this._setSubscriptionTier);

  final SessionController _session;
  final SetSubscriptionTier _setSubscriptionTier;

  final RxBool _subscribing = false.obs;
  final RxnString _error = RxnString();

  /// Whether the current user is a paying Club member (reactive via session).
  bool get isMember => _session.isClubMember;

  /// Whether a subscribe request is in flight (drives the CTA spinner).
  bool get isSubscribing => _subscribing.value;

  /// Message from the last failed subscribe attempt, or `null`.
  String? get errorMessage => _error.value;

  /// Members-only content teased in the "Do Clube" rail (mock data).
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

  /// Mock-subscribes the current user to the paid tier and reflects it on the
  /// session so the Club + Profile tabs update immediately. Returns `true` when
  /// the user newly became a member. No-op (returns `false`) when there is no
  /// signed-in user or they are already a member.
  Future<bool> subscribe() async {
    final uid = _session.currentUserId;
    if (uid == null || isMember || _subscribing.value) return false;

    _error.value = null;
    _subscribing.value = true;
    final result = await _setSubscriptionTier(
      SetSubscriptionTierParams(userId: uid, tier: SubscriptionTier.paid),
    );
    _subscribing.value = false;

    return result.fold(
      (failure) {
        _error.value = failure.message;
        return false;
      },
      (subscription) {
        _session.applySubscriptionTier(subscription.tier);
        return true;
      },
    );
  }
}
