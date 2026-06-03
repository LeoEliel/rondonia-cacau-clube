import '../../domain/core/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../core/firestore_guard.dart';
import '../datasources/user_remote_data_source.dart';
import '../mappers/user_mapper.dart';

/// [UserRepository] backed by Firestore.
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._ds);

  final UserRemoteDataSource _ds;
  final UserMapper _mapper = const UserMapper();

  @override
  Future<Result<User>> getUserById(String uid) {
    return guardFirestore(() async => _mapper.toEntity(
          await _ds.fetchById(uid),
        ));
  }

  @override
  Future<Result<Unit>> followProducer({
    required String uid,
    required String producerId,
  }) {
    return guardFirestore(() async {
      await _ds.follow(uid, producerId);
      return unit;
    });
  }

  @override
  Future<Result<Unit>> unfollowProducer({
    required String uid,
    required String producerId,
  }) {
    return guardFirestore(() async {
      await _ds.unfollow(uid, producerId);
      return unit;
    });
  }
}
