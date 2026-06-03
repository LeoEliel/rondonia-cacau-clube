import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/subscription.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/set_subscription_tier.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:app/presentation/club/controllers/club_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

User _freeUser() => User(
      uid: 'user_free',
      name: 'João Lima',
      email: 'joao@example.com',
      createdAt: DateTime(2024),
    );

Future<({ClubController controller, SessionController session})> _build({
  required User currentUser,
  Result<Subscription>? setResult,
}) async {
  final authRepo = FakeAuthRepository()..currentUserResult = success(currentUser);
  final userRepo = FakeUserRepository();
  final subRepo = FakeSubscriptionRepository()
    ..setResult = setResult ?? success(Samples.subscription(userId: currentUser.uid));

  final session = SessionController(
    GetCurrentUser(authRepo),
    GetUser(userRepo),
    SignOut(authRepo),
    FollowProducer(userRepo),
    UnfollowProducer(userRepo),
  );
  // restore() would re-fetch the profile via GetUser; adopt the auth user
  // directly so the test controls the starting tier.
  await session.completeSignIn(currentUser);

  return (
    controller: ClubController(session, SetSubscriptionTier(subRepo)),
    session: session,
  );
}

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  test('reports membership from the session', () async {
    final paid = await _build(currentUser: Samples.user());
    expect(paid.controller.isMember, isTrue);

    final free = await _build(currentUser: _freeUser());
    expect(free.controller.isMember, isFalse);
  });

  test('exposes members-only content teasers', () async {
    final f = await _build(currentUser: _freeUser());
    expect(f.controller.exclusiveContent, isNotEmpty);
  });

  test('subscribe upgrades the session to the paid tier', () async {
    final f = await _build(currentUser: _freeUser());
    expect(f.controller.isMember, isFalse);

    await f.controller.subscribe();

    expect(f.controller.isMember, isTrue);
    expect(f.session.isClubMember, isTrue);
  });

  test('subscribe is a no-op when already a member', () async {
    final f = await _build(
      currentUser: Samples.user(),
      setResult: failure(const ServerFailure('should not be called')),
    );

    await f.controller.subscribe();

    // Still a member; the failing setResult was never invoked.
    expect(f.controller.isMember, isTrue);
  });

  test('keeps the free tier when the upgrade fails', () async {
    final f = await _build(
      currentUser: _freeUser(),
      setResult: failure(const ServerFailure()),
    );

    await f.controller.subscribe();

    expect(f.controller.isMember, isFalse);
    expect(f.session.isClubMember, isFalse);
  });
}
