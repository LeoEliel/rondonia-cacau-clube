import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Signs a returning user in with email + password.
class SignInWithEmail implements UseCase<User, EmailCredentials> {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(EmailCredentials params) => _repository
      .signInWithEmail(email: params.email, password: params.password);
}

/// Email + password pair for sign-in.
class EmailCredentials {
  const EmailCredentials({required this.email, required this.password});

  final String email;
  final String password;
}
