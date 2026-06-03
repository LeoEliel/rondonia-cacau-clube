import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../core/data_exceptions.dart';
import '../dtos/origin_lot_dto.dart';

/// Firestore-backed origin-lot reads.
class OriginLotRemoteDataSource {
  OriginLotRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.originLots);

  Future<OriginLotDto> fetchById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) {
      throw DataNotFoundException('Lote "$id" não encontrado.');
    }
    return OriginLotDto.fromDoc(doc);
  }
}
