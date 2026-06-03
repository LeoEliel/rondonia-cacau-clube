import '../core/result.dart';
import '../entities/origin_lot.dart';

/// Read access to origin / traceability lots.
abstract interface class OriginLotRepository {
  Future<Result<OriginLot>> getOriginLotById(String id);
}
