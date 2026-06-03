import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../dtos/subscription_dto.dart';

/// Firestore-backed subscription reads/writes (id == userId).
class SubscriptionRemoteDataSource {
  SubscriptionRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.subscriptions);

  Future<SubscriptionDto?> fetch(String userId) async {
    final doc = await _col.doc(userId).get();
    if (!doc.exists) return null;
    return SubscriptionDto.fromDoc(doc);
  }

  /// Writes the subscription record and mirrors the tier onto the user doc so
  /// `users.subscriptionTier` stays in sync (denormalized for quick reads).
  Future<void> set(SubscriptionDto dto) {
    final batch = _firestore.batch()
      ..set(_col.doc(dto.userId), dto.toMap())
      ..update(
        _firestore.collection(FirestorePaths.users).doc(dto.userId),
        {'subscriptionTier': dto.tier},
      );
    return batch.commit();
  }
}
