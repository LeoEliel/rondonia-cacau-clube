import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_paths.dart';
import 'mock_data.dart';

/// Counts written per collection, returned by [FirestoreSeeder.run].
class SeedSummary {
  const SeedSummary({
    required this.producers,
    required this.products,
    required this.originLots,
    required this.users,
    required this.subscriptions,
    required this.reviews,
  });

  final int producers;
  final int products;
  final int originLots;
  final int users;
  final int subscriptions;
  final int reviews;

  int get total =>
      producers + products + originLots + users + subscriptions + reviews;

  @override
  String toString() =>
      'Seed concluído: $producers produtores, $products produtos, '
      '$originLots lotes, $users usuários, $subscriptions assinaturas, '
      '$reviews avaliações ($total documentos).';
}

/// Writes [MockData] into Firestore using deterministic document ids, so
/// re-running overwrites rather than duplicating (idempotent). Uses a single
/// [WriteBatch] (the dataset is well under the 500-write limit).
class FirestoreSeeder {
  FirestoreSeeder(this._firestore);

  final FirebaseFirestore _firestore;

  Future<SeedSummary> run() async {
    final batch = _firestore.batch();

    final producers = _firestore.collection(FirestorePaths.producers);
    for (final p in MockData.producers) {
      batch.set(producers.doc(p.id), p.toMap());
    }

    final products = _firestore.collection(FirestorePaths.products);
    for (final p in MockData.products) {
      batch.set(products.doc(p.id), p.toMap());
    }

    final originLots = _firestore.collection(FirestorePaths.originLots);
    final lots = MockData.originLots;
    for (final l in lots) {
      batch.set(originLots.doc(l.id), l.toMap());
    }

    final users = _firestore.collection(FirestorePaths.users);
    for (final u in MockData.users) {
      batch.set(users.doc(u.uid), u.toMap());
    }

    final subscriptions = _firestore.collection(FirestorePaths.subscriptions);
    for (final s in MockData.subscriptions) {
      batch.set(subscriptions.doc(s.userId), s.toMap());
    }

    final reviews = _firestore.collection(FirestorePaths.reviews);
    for (final r in MockData.reviews) {
      batch.set(reviews.doc(r.id), r.toMap());
    }

    await batch.commit();

    return SeedSummary(
      producers: MockData.producers.length,
      products: MockData.products.length,
      originLots: lots.length,
      users: MockData.users.length,
      subscriptions: MockData.subscriptions.length,
      reviews: MockData.reviews.length,
    );
  }
}
