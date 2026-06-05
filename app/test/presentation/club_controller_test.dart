import 'package:app/core/session/session_controller.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/usecases/check_premium.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_offerings.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/purchase_premium.dart';
import 'package:app/domain/usecases/restore_purchases.dart';
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

Future<
    ({
      ClubController controller,
      SessionController session,
      FakePurchasesRepository purchases,
    })> _build({
  required User currentUser,
  Result<bool>? purchaseResult,
  Result<bool>? restoreResult,
  Result<bool>? premiumResult,
}) async {
  final authRepo = FakeAuthRepository()
    ..currentUserResult = success(currentUser);
  final userRepo = FakeUserRepository();
  final purchases = FakePurchasesRepository();
  if (purchaseResult != null) purchases.purchaseResult = purchaseResult;
  if (restoreResult != null) purchases.restoreResult = restoreResult;
  if (premiumResult != null) purchases.premiumResult = premiumResult;

  final session = SessionController(
    GetCurrentUser(authRepo),
    GetUser(userRepo),
    SignOut(authRepo),
    FollowProducer(userRepo),
    UnfollowProducer(userRepo),
  );
  // FakeUserRepository fails getUserById, so completeSignIn keeps the auth user
  // as-is — the test controls the starting tier through [currentUser].
  await session.completeSignIn(currentUser);

  final controller = ClubController(
    session,
    GetOfferings(purchases),
    PurchasePremium(purchases),
    RestorePurchases(purchases),
    CheckPremium(purchases),
  );
  controller.onInit(); // seeds premium from the session
  await controller.load(); // settles offerings + premium check

  return (controller: controller, session: session, purchases: purchases);
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

  test('loads the offering packages', () async {
    final f = await _build(currentUser: _freeUser());
    expect(f.controller.packages, isNotEmpty);
    expect(f.controller.primaryPackage?.id, 'premium');
  });

  test('subscribe purchases the package and unlocks premium', () async {
    final f = await _build(
      currentUser: _freeUser(),
      purchaseResult: success(true),
    );
    expect(f.controller.isMember, isFalse);

    final ok = await f.controller.subscribe();

    expect(ok, isTrue);
    expect(f.controller.isMember, isTrue);
    expect(f.session.isClubMember, isTrue);
    expect(f.purchases.purchaseCalled, isTrue);
    expect(f.purchases.lastUserId, 'user_free');
    expect(f.purchases.lastPackage?.id, 'premium');
  });

  test('subscribe is a no-op when already a member', () async {
    final f = await _build(
      currentUser: Samples.user(),
      purchaseResult: failure(const ServerFailure('should not be called')),
    );

    final ok = await f.controller.subscribe();

    expect(ok, isFalse);
    expect(f.controller.isMember, isTrue);
    expect(f.purchases.purchaseCalled, isFalse);
  });

  test('keeps the free tier when the purchase fails', () async {
    final f = await _build(
      currentUser: _freeUser(),
      purchaseResult: failure(const ServerFailure('Falhou')),
    );

    final ok = await f.controller.subscribe();

    expect(ok, isFalse);
    expect(f.controller.isMember, isFalse);
    expect(f.session.isClubMember, isFalse);
    expect(f.controller.errorMessage, 'Falhou');
  });

  test('restore unlocks premium when a purchase is found', () async {
    final f = await _build(
      currentUser: _freeUser(),
      restoreResult: success(true),
    );

    final restored = await f.controller.restore();

    expect(restored, isTrue);
    expect(f.controller.isMember, isTrue);
    expect(f.session.isClubMember, isTrue);
    expect(f.purchases.restoreCalled, isTrue);
  });

  test('restore reports no purchase to restore', () async {
    final f = await _build(
      currentUser: _freeUser(),
      restoreResult: success(false),
    );

    final restored = await f.controller.restore();

    expect(restored, isFalse);
    expect(f.controller.isMember, isFalse);
    expect(f.purchases.restoreCalled, isTrue);
  });

  test('restore surfaces the failure message', () async {
    final f = await _build(
      currentUser: _freeUser(),
      restoreResult: failure(const ServerFailure('Sem conexão')),
    );

    final restored = await f.controller.restore();

    expect(restored, isFalse);
    expect(f.controller.isMember, isFalse);
    expect(f.controller.errorMessage, 'Sem conexão');
  });
}
