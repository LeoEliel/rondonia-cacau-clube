import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';

import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Firebase-backed [AuthRepository] (production path).
///
/// Maps the Firebase Auth user onto the domain [User] so nothing upstream sees
/// a Firebase type, and translates [fb.FirebaseAuthException]s into pt-BR
/// [AuthFailure]s. The richer profile (subscription tier, followed producers)
/// is hydrated from Firestore by the `SessionController` after sign-in.
///
/// Google sign-in uses the Firebase popup flow, which only exists on web;
/// native Google auth needs the `google_sign_in` package and OAuth clients,
/// deferred until those are provisioned.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository([fb.FirebaseAuth? auth])
      : _auth = auth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  @override
  Future<Result<User?>> currentUser() async {
    final fbUser = _auth.currentUser;
    return success(fbUser == null ? null : _toEntity(fbUser));
  }

  @override
  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return success(_toEntity(credential.user!));
    } on fb.FirebaseAuthException catch (e) {
      return failure(_mapError(e));
    } catch (_) {
      return failure(const UnknownFailure());
    }
  }

  @override
  Future<Result<User>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user!.updateDisplayName(name.trim());
      await credential.user!.reload();
      return success(_toEntity(_auth.currentUser ?? credential.user!));
    } on fb.FirebaseAuthException catch (e) {
      return failure(_mapError(e));
    } catch (_) {
      return failure(const UnknownFailure());
    }
  }

  @override
  Future<Result<User>> signInWithGoogle() async {
    if (!kIsWeb) {
      return failure(const AuthFailure(
        'Login com Google está disponível apenas na versão web por enquanto.',
      ));
    }
    try {
      final credential =
          await _auth.signInWithPopup(fb.GoogleAuthProvider());
      return success(_toEntity(credential.user!));
    } on fb.FirebaseAuthException catch (e) {
      return failure(_mapError(e));
    } catch (_) {
      return failure(const UnknownFailure());
    }
  }

  @override
  Future<Result<Unit>> signOut() async {
    await _auth.signOut();
    return success(unit);
  }

  /// Builds the domain [User] from the Firebase account. Profile fields the
  /// auth record doesn't hold (tier, following) default to a free, empty state
  /// and are hydrated from Firestore downstream.
  User _toEntity(fb.User u) => User(
        uid: u.uid,
        name: u.displayName?.trim().isNotEmpty == true
            ? u.displayName!.trim()
            : (u.email?.split('@').first ?? 'Visitante'),
        email: u.email ?? '',
        photoUrl: u.photoURL,
        createdAt: u.metadata.creationTime ?? DateTime.now(),
      );

  AuthFailure _mapError(fb.FirebaseAuthException e) {
    final message = switch (e.code) {
      'invalid-email' => 'E-mail inválido.',
      'user-disabled' => 'Esta conta foi desativada.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' =>
        'E-mail ou senha incorretos.',
      'email-already-in-use' => 'Este e-mail já está cadastrado.',
      'weak-password' => 'A senha precisa ter ao menos 6 caracteres.',
      'network-request-failed' => 'Falha de conexão. Tente novamente.',
      'too-many-requests' =>
        'Muitas tentativas. Aguarde um momento e tente de novo.',
      'popup-closed-by-user' => 'Login com Google cancelado.',
      _ => 'Não foi possível concluir. Tente novamente.',
    };
    return AuthFailure(message);
  }
}
