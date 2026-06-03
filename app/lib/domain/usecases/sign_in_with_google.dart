import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Signs in with a Google account (federated).
class SignInWithGoogle implements UseCase<User, NoParams> {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(NoParams params) => _repository.signInWithGoogle();
}
