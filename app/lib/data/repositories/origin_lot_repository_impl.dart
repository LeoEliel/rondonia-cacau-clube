import '../../domain/core/result.dart';
import '../../domain/entities/origin_lot.dart';
import '../../domain/repositories/origin_lot_repository.dart';
import '../core/firestore_guard.dart';
import '../datasources/origin_lot_remote_data_source.dart';
import '../mappers/origin_lot_mapper.dart';

/// [OriginLotRepository] backed by Firestore.
class OriginLotRepositoryImpl implements OriginLotRepository {
  OriginLotRepositoryImpl(this._ds);

  final OriginLotRemoteDataSource _ds;
  final OriginLotMapper _mapper = const OriginLotMapper();

  @override
  Future<Result<OriginLot>> getOriginLotById(String id) {
    return guardFirestore(
      () async => _mapper.toEntity(await _ds.fetchById(id)),
    );
  }
}
