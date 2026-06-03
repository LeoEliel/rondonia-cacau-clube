import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Fetches a user profile by uid.
class GetUser implements UseCase<User, String> {
  const GetUser(this._repository);

  final UserRepository _repository;

  @override
  Future<Result<User>> call(String params) => _repository.getUserById(params);
}
