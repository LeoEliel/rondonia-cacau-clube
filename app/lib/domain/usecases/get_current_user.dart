import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Restores the signed-in user when the app starts; `null` when anonymous.
class GetCurrentUser implements UseCase<User?, NoParams> {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User?>> call(NoParams params) => _repository.currentUser();
}
