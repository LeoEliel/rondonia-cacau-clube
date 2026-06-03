import '../core/result.dart';
import '../entities/user.dart';

/// Read access to user profiles plus follow/unfollow mutations.
abstract interface class UserRepository {
  Future<Result<User>> getUserById(String uid);

  Future<Result<Unit>> followProducer({
    required String uid,
    required String producerId,
  });

  Future<Result<Unit>> unfollowProducer({
    required String uid,
    required String producerId,
  });
}
