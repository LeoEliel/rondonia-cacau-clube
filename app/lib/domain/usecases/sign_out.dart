import '../core/result.dart';
import '../core/usecase.dart';
import '../repositories/auth_repository.dart';

/// Ends the current session.
class SignOut implements UseCase<Unit, NoParams> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<Unit>> call(NoParams params) => _repository.signOut();
}
