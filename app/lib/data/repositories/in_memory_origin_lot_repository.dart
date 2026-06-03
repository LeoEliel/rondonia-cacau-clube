import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import '../../domain/entities/origin_lot.dart';
import '../../domain/repositories/origin_lot_repository.dart';
import '../mappers/origin_lot_mapper.dart';
import '../../seed/mock_data.dart';

/// Offline [OriginLotRepository] backed by [MockData] (demo mode), so the
/// Product Detail traceability section works without a seeded Firestore.
class InMemoryOriginLotRepository implements OriginLotRepository {
  final OriginLotMapper _mapper = const OriginLotMapper();

  List<OriginLot> get _all =>
      MockData.originLots.map(_mapper.toEntity).toList();

  @override
  Future<Result<OriginLot>> getOriginLotById(String id) async {
    final match = _all.where((l) => l.id == id);
    return match.isEmpty
        ? failure(NotFoundFailure('Lote "$id" não encontrado.'))
        : success(match.first);
  }
}
