import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

({
  SessionController controller,
  FakeAuthRepository authRepo,
  FakeUserRepository userRepo,
}) _build({
  Result<User?>? currentUserResult,
  Result<User>? profileResult,
  Result<Unit>? followResult,
  Result<Unit>? unfollowResult,
}) {
  final authRepo = FakeAuthRepository()
    ..currentUserResult = currentUserResult ?? success(null);
  final userRepo = FakeUserRepository()
    ..userResult = profileResult ?? success(Samples.user())
    ..followResult = followResult ?? success(unit)
    ..unfollowResult = unfollowResult ?? success(unit);

  return (
    controller: SessionController(
      GetCurrentUser(authRepo),
      GetUser(userRepo),
      SignOut(authRepo),
      FollowProducer(userRepo),
      UnfollowProducer(userRepo),
    ),
    authRepo: authRepo,
    userRepo: userRepo,
  );
}

void main() {
  group('SessionController.restore', () {
    test('adopts a persisted user and seeds the following set', () async {
      final f = _build(currentUserResult: success(Samples.user()));

      await f.controller.restore();

      expect(f.controller.isAuthenticated, isTrue);
      expect(f.controller.currentUserId, 'user_ana');
      expect(f.controller.isFollowing('prod_1'), isTrue);
      expect(f.controller.isFollowing('prod_other'), isFalse);
    });

    test('stays anonymous when there is no persisted session', () async {
      final f = _build(currentUserResult: success(null));

      await f.controller.restore();

      expect(f.controller.isAuthenticated, isFalse);
      expect(f.controller.currentUserId, isNull);
      expect(f.controller.following, isEmpty);
    });
  });

  group('SessionController.completeSignIn', () {
    test('adopts the auth user and hydrates the richer profile', () async {
      final f = _build(
        profileResult: success(Samples.user()),
      );

      await f.controller.completeSignIn(
        User(
          uid: 'user_ana',
          name: 'Ana',
          email: 'ana@example.com',
          createdAt: DateTime(2024),
        ),
      );

      expect(f.controller.isAuthenticated, isTrue);
      // Hydrated profile carries the paid tier + seeded following set.
      expect(f.controller.isClubMember, isTrue);
      expect(f.controller.isFollowing('prod_1'), isTrue);
    });

    test('keeps the auth user when no persisted profile exists', () async {
      final f = _build(profileResult: failure(const NotFoundFailure()));

      await f.controller.completeSignIn(
        User(
          uid: 'user_new',
          name: 'Novo',
          email: 'novo@example.com',
          createdAt: DateTime(2024),
        ),
      );

      expect(f.controller.currentUserId, 'user_new');
      expect(f.controller.isClubMember, isFalse);
    });
  });

  group('SessionController.signOut', () {
    test('clears identity and follow state', () async {
      final f = _build(currentUserResult: success(Samples.user()));
      await f.controller.restore();

      await f.controller.signOut();

      expect(f.authRepo.didSignOut, isTrue);
      expect(f.controller.isAuthenticated, isFalse);
      expect(f.controller.following, isEmpty);
    });
  });

  group('SessionController.toggleFollow', () {
    test('follows optimistically and persists on success', () async {
      final f = _build(currentUserResult: success(Samples.user()));
      await f.controller.restore();

      await f.controller.toggleFollow('prod_new');

      expect(f.controller.isFollowing('prod_new'), isTrue);
      expect(f.userRepo.lastFollowProducerId, 'prod_new');
      expect(f.userRepo.lastFollowUid, 'user_ana');
    });

    test('does nothing when anonymous', () async {
      final f = _build(currentUserResult: success(null));
      await f.controller.restore();

      await f.controller.toggleFollow('prod_new');

      expect(f.controller.isFollowing('prod_new'), isFalse);
      expect(f.userRepo.lastFollowProducerId, isNull);
    });

    test('rolls back the follow when the write fails', () async {
      final f = _build(
        currentUserResult: success(Samples.user()),
        followResult: failure(const ServerFailure()),
      );
      await f.controller.restore();

      await f.controller.toggleFollow('prod_new');

      expect(f.controller.isFollowing('prod_new'), isFalse);
    });

    test('unfollows an already-followed producer', () async {
      final f = _build(currentUserResult: success(Samples.user()));
      await f.controller.restore();

      await f.controller.toggleFollow('prod_1');

      expect(f.controller.isFollowing('prod_1'), isFalse);
      expect(f.userRepo.lastUnfollowProducerId, 'prod_1');
    });

    test('rolls back the unfollow when the write fails', () async {
      final f = _build(
        currentUserResult: success(Samples.user()),
        unfollowResult: failure(const ServerFailure()),
      );
      await f.controller.restore();

      await f.controller.toggleFollow('prod_1');

      expect(f.controller.isFollowing('prod_1'), isTrue);
    });
  });
}
