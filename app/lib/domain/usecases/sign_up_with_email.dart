import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Creates a new account from a name, email and password.
class SignUpWithEmail implements UseCase<User, SignUpData> {
  const SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(SignUpData params) => _repository.signUpWithEmail(
    name: params.name,
    email: params.email,
    password: params.password,
  );
}

/// Registration details for a new account.
class SignUpData {
  const SignUpData({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}
