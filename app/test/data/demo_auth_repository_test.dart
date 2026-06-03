import 'package:app/data/repositories/demo_auth_repository.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/entities/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DemoAuthRepository', () {
    test('starts anonymous', () async {
      final repo = DemoAuthRepository();

      final result = await repo.currentUser();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected success'), (user) {
        expect(user, isNull);
      });
    });

    test('email sign-in resolves to the seeded Club member', () async {
      final repo = DemoAuthRepository();

      final result =
          await repo.signInWithEmail(email: 'a@b.com', password: '123456');

      result.fold((_) => fail('expected success'), (user) {
        expect(user.subscriptionTier, SubscriptionTier.paid);
        expect(user.followingProducerIds, isNotEmpty);
      });
      // The session is now remembered.
      final restored = await repo.currentUser();
      restored.fold((_) => fail('expected success'), (u) => expect(u, isNotNull));
    });

    test('email sign-in rejects empty credentials', () async {
      final repo = DemoAuthRepository();

      final result = await repo.signInWithEmail(email: '', password: '');

      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<ValidationFailure>()), (_) {});
    });

    test('sign-up mints a fresh free-tier account', () async {
      final repo = DemoAuthRepository();

      final result = await repo.signUpWithEmail(
        name: 'Bia',
        email: 'bia@email.com',
        password: 'secret1',
      );

      result.fold((_) => fail('expected success'), (user) {
        expect(user.name, 'Bia');
        expect(user.email, 'bia@email.com');
        expect(user.subscriptionTier, SubscriptionTier.free);
        expect(user.isClubMember, isFalse);
      });
    });

    test('sign-out clears the current session', () async {
      final repo = DemoAuthRepository();
      await repo.signInWithEmail(email: 'a@b.com', password: '123456');

      await repo.signOut();

      final result = await repo.currentUser();
      result.fold((_) => fail('expected success'), (u) => expect(u, isNull));
    });
  });
}
