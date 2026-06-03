import 'package:get/get.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/follow_producer.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/unfollow_producer.dart';

/// App-wide "who is using the app" state.
///
/// Authentication (Firebase Auth) lands in Milestone 5; until then this exposes
/// a fixed **demo identity** so the follow and review features have a current
/// user to act as. When auth arrives, only [_demoUid] / [load] change here —
/// every screen already reads identity through this controller, so nothing
/// downstream is touched.
///
/// Registered permanently in `InitialBinding` and looked up by the Producer
/// Profile and Reviews controllers. The followed-producers set is held
/// reactively and updated optimistically so the UI flips instantly while the
/// repository write is in flight.
class SessionController extends GetxController {
  SessionController(this._getUser, this._followProducer, this._unfollowProducer);

  final GetUser _getUser;
  final FollowProducer _followProducer;
  final UnfollowProducer _unfollowProducer;

  /// Demo identity used until Milestone 5 wires real auth. Matches a seeded
  /// user in `MockData` / Firestore so the followed set starts populated.
  static const String _demoUid = 'user_ana';

  final Rxn<User> _user = Rxn<User>();
  final RxSet<String> _following = <String>{}.obs;

  User? get user => _user.value;
  String get currentUserId => _user.value?.uid ?? _demoUid;
  String? get currentUserName => _user.value?.name;
  String? get currentUserPhotoUrl => _user.value?.photoUrl;

  /// Reactive view of the producers the current user follows.
  Set<String> get following => _following;

  bool isFollowing(String producerId) => _following.contains(producerId);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final result = await _getUser(_demoUid);
    result.fold(
      (_) => null, // No profile yet (e.g. fresh backend) — start empty.
      (user) {
        _user.value = user;
        _following
          ..clear()
          ..addAll(user.followingProducerIds);
      },
    );
  }

  /// Toggles follow state for [producerId]. Updates local state immediately and
  /// rolls back if the repository write fails.
  Future<void> toggleFollow(String producerId) async {
    final wasFollowing = _following.contains(producerId);
    if (wasFollowing) {
      _following.remove(producerId);
    } else {
      _following.add(producerId);
    }

    final params = FollowProducerParams(
      uid: currentUserId,
      producerId: producerId,
    );
    final result =
        wasFollowing ? await _unfollowProducer(params) : await _followProducer(params);

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
