import '../core/result.dart';
import '../core/usecase.dart';
import '../repositories/user_repository.dart';
import 'follow_producer.dart' show FollowProducerParams;

/// Removes a producer from the user's following list.
class UnfollowProducer implements UseCase<Unit, FollowProducerParams> {
  const UnfollowProducer(this._repository);

  final UserRepository _repository;

  @override
  Future<Result<Unit>> call(FollowProducerParams params) => _repository
      .unfollowProducer(uid: params.uid, producerId: params.producerId);
}
