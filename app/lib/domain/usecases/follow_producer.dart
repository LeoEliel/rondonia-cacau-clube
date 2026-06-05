import '../core/result.dart';
import '../core/usecase.dart';
import '../repositories/user_repository.dart';

/// Adds a producer to the user's following list.
class FollowProducer implements UseCase<Unit, FollowProducerParams> {
  const FollowProducer(this._repository);

  final UserRepository _repository;

  @override
  Future<Result<Unit>> call(FollowProducerParams params) => _repository
      .followProducer(uid: params.uid, producerId: params.producerId);
}

/// Input for [FollowProducer] / [UnfollowProducer].
class FollowProducerParams {
  const FollowProducerParams({required this.uid, required this.producerId});

  final String uid;
  final String producerId;
}
