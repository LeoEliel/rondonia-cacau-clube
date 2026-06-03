import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../core/data_exceptions.dart';
import '../dtos/user_dto.dart';

/// Firestore-backed user reads plus follow/unfollow mutations.
class UserRemoteDataSource {
  UserRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestorePaths.users);

  CollectionReference<Map<String, dynamic>> get _producers =>
      _firestore.collection(FirestorePaths.producers);

  Future<UserDto> fetchById(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) {
      throw DataNotFoundException('Usuário "$uid" não encontrado.');
    }
    return UserDto.fromDoc(doc);
  }

  /// Atomically adds [producerId] to the user's following list and bumps the
  /// producer's follower count.
  Future<void> follow(String uid, String producerId) {
    final batch = _firestore.batch()
      ..update(_users.doc(uid), {
        'followingProducerIds': FieldValue.arrayUnion([producerId]),
      })
      ..update(_producers.doc(producerId), {
        'followerCount': FieldValue.increment(1),
      });
    return batch.commit();
  }

  Future<void> unfollow(String uid, String producerId) {
    final batch = _firestore.batch()
      ..update(_users.doc(uid), {
        'followingProducerIds': FieldValue.arrayRemove([producerId]),
      })
      ..update(_producers.doc(producerId), {
        'followerCount': FieldValue.increment(-1),
      });
    return batch.commit();
  }
}
