import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../mappers/user_mapper.dart';
import '../../seed/mock_data.dart';

/// Offline [AuthRepository] for demo mode.
///
/// Accepts any credentials so the prototype's sign-in flow can be exercised
/// without a real backend. A successful sign-in resolves to the first seeded
/// [MockData] user (Ana — a paid Club member already following producers) so
/// the follow / reviews / Club features have rich state to show. Sign-up mints
/// a fresh free-tier account. The "current user" starts `null`, so the app
/// opens on onboarding until the user signs in.
class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository() {
    const mapper = UserMapper();
    _seededUser = mapper.toEntity(MockData.users.first);
  }

  late final User _seededUser;
  User? _current;

  @override
  Future<Result<User?>> currentUser() async => success(_current);

  @override
  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return failure(const ValidationFailure('Informe e-mail e senha.'));
    }
    _current = _seededUser;
    return success(_seededUser);
  }

  @override
  Future<Result<User>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      return failure(const ValidationFailure('Preencha todos os campos.'));
    }
    final user = User(
      uid: 'user_demo_new',
      name: name.trim(),
      email: email.trim(),
      createdAt: DateTime.now(),
    );
    _current = user;
    return success(user);
  }

  @override
  Future<Result<User>> signInWithGoogle() async {
    _current = _seededUser;
    return success(_seededUser);
  }

  @override
  Future<Result<Unit>> signOut() async {
    _current = null;
    return success(unit);
  }
}
