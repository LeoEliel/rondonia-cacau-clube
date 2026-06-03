import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

void main() {
  late FakeUserRepository repo;

  setUp(() => repo = FakeUserRepository());

  const params = FollowProducerParams(uid: 'user_ana', producerId: 'prod_1');

  test('FollowProducer forwards uid + producerId and succeeds', () async {
    final result = await FollowProducer(repo)(params);

    expect(repo.lastFollowUid, 'user_ana');
    expect(repo.lastFollowProducerId, 'prod_1');
    expect(result.isRight(), isTrue);
  });

  test('FollowProducer propagates a failure', () async {
    repo.followResult = failure(const AuthFailure());

    final result = await FollowProducer(repo)(params);

    expect(result.isLeft(), isTrue);
  });

  test('UnfollowProducer forwards producerId and succeeds', () async {
    final result = await UnfollowProducer(repo)(params);

    expect(repo.lastUnfollowProducerId, 'prod_1');
    expect(result.isRight(), isTrue);
  });
}
