import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../core/data_exceptions.dart';
import '../dtos/producer_dto.dart';

/// Firestore-backed producer reads.
class ProducerRemoteDataSource {
  ProducerRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.producers);

  Future<List<ProducerDto>> fetchProducers() async {
    final snap = await _col.get();
    final items = snap.docs.map(ProducerDto.fromDoc).toList();
    items.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return items;
  }

  Future<ProducerDto> fetchProducerById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) {
      throw DataNotFoundException('Produtor "$id" não encontrado.');
    }
    return ProducerDto.fromDoc(doc);
  }
}
