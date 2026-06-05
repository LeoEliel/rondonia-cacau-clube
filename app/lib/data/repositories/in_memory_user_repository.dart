import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../mappers/user_mapper.dart';
import '../../seed/mock_data.dart';

/// Offline [UserRepository] backed by [MockData] (demo mode).
///
/// Holds a mutable per-user following set so follow / unfollow toggles persist
/// for the lifetime of the session, mirroring the Firestore implementation's
/// observable behavior without a backend.
class InMemoryUserRepository implements UserRepository {
  InMemoryUserRepository() {
    const mapper = UserMapper();
    for (final dto in MockData.users) {
      _following[dto.uid] = {...dto.followingProducerIds};
      _users[dto.uid] = mapper.toEntity(dto);
    }
  }

  final Map<String, User> _users = {};
  final Map<String, Set<String>> _following = {};

  @override
  Future<Result<User>> getUserById(String uid) async {
    final user = _users[uid];
    if (user == null) {
      return failure(NotFoundFailure('Usuário "$uid" não encontrado.'));
    }
    return success(
      User(
        uid: user.uid,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
        subscriptionTier: user.subscriptionTier,
        followingProducerIds: _following[uid]?.toList() ?? const [],
        createdAt: user.createdAt,
      ),
    );
  }

  @override
  Future<Result<Unit>> followProducer({
    required String uid,
    required String producerId,
  }) async {
    (_following[uid] ??= {}).add(producerId);
    return success(unit);
  }

  @override
  Future<Result<Unit>> unfollowProducer({
    required String uid,
    required String producerId,
  }) async {
    _following[uid]?.remove(producerId);
    return success(unit);
  }
}
