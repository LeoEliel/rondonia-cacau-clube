import '../core/result.dart';
import '../entities/user.dart';

/// Authentication boundary for the app.
///
/// Returns the domain [User] on success so the rest of the app never touches a
/// Firebase Auth type. Two implementations exist: a Firebase-backed one for
/// production and an in-memory demo one (selected via the `DEMO` flag, mirroring
/// the catalog repositories) so the prototype runs without a live backend.
abstract interface class AuthRepository {
  /// The currently signed-in user, or `null` if the session is anonymous.
  /// Used to restore the session when the app starts.
  Future<Result<User?>> currentUser();

  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<User>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  /// Federated Google sign-in. Available on web (Firebase popup) and in demo
  /// mode; native mobile support is deferred until OAuth clients are set up.
  Future<Result<User>> signInWithGoogle();

  Future<Result<Unit>> signOut();
}
