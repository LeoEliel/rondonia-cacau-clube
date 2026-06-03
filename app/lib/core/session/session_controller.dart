import 'package:get/get.dart';

import '../../domain/core/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/follow_producer.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/unfollow_producer.dart';

/// App-wide "who is using the app" state.
///
/// Owns the authenticated [User] and the set of producers they follow. The auth
/// screens (login / signup) hand the signed-in user here via [completeSignIn];
/// every other screen reads identity through this controller, so they never
/// touch the auth layer directly. On startup it restores any existing session
/// via [GetCurrentUser].
///
/// Registered permanently in `InitialBinding`. The followed-producers set is
/// held reactively and updated optimistically so the UI flips instantly while
/// the repository write is in flight.
class SessionController extends GetxController {
  SessionController(
    this._getCurrentUser,
    this._getUser,
    this._signOut,
    this._followProducer,
    this._unfollowProducer,
  );

  final GetCurrentUser _getCurrentUser;
  final GetUser _getUser;
  final SignOut _signOut;
  final FollowProducer _followProducer;
  final UnfollowProducer _unfollowProducer;

  final Rxn<User> _user = Rxn<User>();
  final RxSet<String> _following = <String>{}.obs;

  User? get user => _user.value;
  bool get isAuthenticated => _user.value != null;
  String? get currentUserId => _user.value?.uid;
  String? get currentUserName => _user.value?.name;
  String? get currentUserEmail => _user.value?.email;
  String? get currentUserPhotoUrl => _user.value?.photoUrl;
  bool get isClubMember => _user.value?.isClubMember ?? false;

  /// Reactive view of the producers the current user follows.
  Set<String> get following => _following;

  bool isFollowing(String producerId) => _following.contains(producerId);

  @override
  void onInit() {
    super.onInit();
    restore();
  }

  /// Restores a persisted session on startup (no-op when anonymous).
  Future<void> restore() async {
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (_) => null,
      (user) {
        if (user != null) _adoptUser(user);
      },
    );
  }

  /// Adopts the user returned by a successful sign-in / sign-up and hydrates
  /// the richer persisted profile (subscription tier, followed producers) when
  /// one exists — falling back to the auth-provided user otherwise (e.g. a
  /// brand-new account with no profile document yet).
  Future<void> completeSignIn(User authUser) async {
    _adoptUser(authUser);
    final profile = await _getUser(authUser.uid);
    profile.fold((_) => null, _adoptUser);
  }

  void _adoptUser(User user) {
    _user.value = user;
    _following
      ..clear()
      ..addAll(user.followingProducerIds);
  }

  /// Ends the session and clears local identity + follow state.
  Future<void> signOut() async {
    await _signOut(const NoParams());
    _user.value = null;
    _following.clear();
  }

  /// Toggles follow state for [producerId]. Updates local state immediately and
  /// rolls back if the repository write fails.
  Future<void> toggleFollow(String producerId) async {
    final uid = currentUserId;
    if (uid == null) return; // No identity → nothing to persist.

    final wasFollowing = _following.contains(producerId);
    if (wasFollowing) {
      _following.remove(producerId);
    } else {
      _following.add(producerId);
    }

    final params = FollowProducerParams(uid: uid, producerId: producerId);
    final result = wasFollowing
        ? await _unfollowProducer(params)
        : await _followProducer(params);

    result.fold(
      (_) {
        // Revert the optimistic change on failure.
        if (wasFollowing) {
          _following.add(producerId);
        } else {
          _following.remove(producerId);
        }
      },
      (_) => null,
    );
  }
}
