import 'package:firebase_core/firebase_core.dart';

import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import 'data_exceptions.dart';

/// Runs a data-layer [body] and converts any thrown exception into a domain
/// [Failure], returning a [Result]. This is the single place where raw
/// Firebase/platform errors are translated — repositories stay free of
/// try/catch noise and the domain never sees a Firebase type.
Future<Result<T>> guardFirestore<T>(Future<T> Function() body) async {
  try {
    return success(await body());
  } on DataNotFoundException catch (e) {
    return failure(NotFoundFailure(e.message));
  } on FirebaseException catch (e) {
    return failure(_mapFirebase(e));
  } catch (e) {
    return failure(UnknownFailure(e.toString()));
  }
}

Failure _mapFirebase(FirebaseException e) {
  switch (e.code) {
    case 'unavailable':
    case 'deadline-exceeded':
      return const NetworkFailure();
    case 'permission-denied':
    case 'unauthenticated':
      return const AuthFailure('Sem permissão para esta operação.');
    case 'not-found':
      return const NotFoundFailure();
    default:
      return ServerFailure(e.message ?? 'Erro no servidor.');
  }
}
