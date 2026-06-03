import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

({SessionController controller, FakeUserRepository userRepo}) _build({
  Result<User>? userResult,
  Result<Unit>? followResult,
  Result<Unit>? unfollowResult,
}) {
  final userRepo = FakeUserRepository()
    ..userResult = userResult ?? success(Samples.user())
    ..followResult = followResult ?? success(unit)
    ..unfollowResult = unfollowResult ?? success(unit);

  return (
    controller: SessionController(
      GetUser(userRepo),
      FollowProducer(userRepo),
      UnfollowProducer(userRepo),
    ),
    userRepo: userRepo,
  );
}

void main() {
  group('SessionController.load', () {
    test('seeds the following set from the loaded user', () async {
      final f = _build();

      await f.controller.load();

      expect(f.controller.currentUserId, 'user_ana');
      expect(f.controller.isFollowing('prod_1'), isTrue);
      expect(f.controller.isFollowing('prod_other'), isFalse);
    });

    test('falls back to the demo id and empty set when the user is missing',
        () async {
      final f = _build(userResult: failure(const NotFoundFailure()));

      await f.controller.load();

      expect(f.controller.currentUserId, 'user_ana');
      expect(f.controller.following, isEmpty);
    });
  });

  group('SessionController.toggleFollow', () {
    test('follows optimistically and persists on success', () async {
      final f = _build();
      await f.controller.load();

      await f.controller.toggleFollow('prod_new');

      expect(f.controller.isFollowing('prod_new'), isTrue);
      expect(f.userRepo.lastFollowProducerId, 'prod_new');
      expect(f.userRepo.lastFollowUid, 'user_ana');
    });

    test('rolls back the follow when the write fails', () async {
      final f = _build(followResult: failure(const ServerFailure()));
      await f.controller.load();

      await f.controller.toggleFollow('prod_new');

      expect(f.controller.isFollowing('prod_new'), isFalse);
    });

    test('unfollows an already-followed producer', () async {
      final f = _build();
      await f.controller.load();

      await f.controller.toggleFollow('prod_1');

      expect(f.controller.isFollowing('prod_1'), isFalse);
      expect(f.userRepo.lastUnfollowProducerId, 'prod_1');
    });

    test('rolls back the unfollow when the write fails', () async {
      final f = _build(unfollowResult: failure(const ServerFailure()));
      await f.controller.load();

      await f.controller.toggleFollow('prod_1');

      expect(f.controller.isFollowing('prod_1'), isTrue);
    });
  });
}
