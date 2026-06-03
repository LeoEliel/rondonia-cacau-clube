import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/enums.dart';
import 'package:app/domain/usecases/get_subscription.dart';
import 'package:app/domain/usecases/set_subscription_tier.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';
import '../../helpers/samples.dart';

void main() {
  group('GetSubscription', () {
    test('returns null when the user has no subscription', () async {
      final repo = FakeSubscriptionRepository()..getResult = success(null);

      final result = await GetSubscription(repo)('user_joao');

      expect(repo.lastUserId, 'user_joao');
      expect(result.getOrElse(() => Samples.subscription()), isNull);
    });

    test('returns the subscription when present', () async {
      final repo = FakeSubscriptionRepository()
        ..getResult = success(Samples.subscription());

      final result = await GetSubscription(repo)('user_ana');

      expect(result.getOrElse(() => null)?.isActivePaid, isTrue);
    });
  });

  group('SetSubscriptionTier', () {
    test('forwards userId + tier and returns the subscription', () async {
      final repo = FakeSubscriptionRepository()
        ..setResult = success(Samples.subscription());

      final result = await SetSubscriptionTier(repo)(
        const SetSubscriptionTierParams(
          userId: 'user_ana',
          tier: SubscriptionTier.paid,
        ),
      );

      expect(repo.lastUserId, 'user_ana');
      expect(repo.lastTier, SubscriptionTier.paid);
      expect(result.isRight(), isTrue);
    });
  });
}
