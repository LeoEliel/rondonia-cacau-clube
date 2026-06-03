/// Base type for all recoverable, domain-level errors.
///
/// The domain layer is pure Dart: it never throws Firebase/platform exceptions
/// across boundaries. Data sources translate raw exceptions into a [Failure],
/// which use cases surface through a [Result].
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// Network / connectivity problem.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Falha de conexão.']);
}

/// Backend / remote data source error (e.g. Firestore unavailable).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erro no servidor.']);
}

/// Authentication / authorization error.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Falha de autenticação.']);
}

/// Requested resource was not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso não encontrado.']);
}

/// Local cache / storage error.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro de armazenamento local.']);
}

/// Fallback for anything unclassified.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Ocorreu um erro inesperado.']);
}
