import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/origin_lot.dart';
import '../repositories/origin_lot_repository.dart';

/// Fetches the origin lot (traceability timeline + map pin) for a product.
class GetOriginLot implements UseCase<OriginLot, String> {
  const GetOriginLot(this._repository);

  final OriginLotRepository _repository;

  @override
  Future<Result<OriginLot>> call(String params) =>
      _repository.getOriginLotById(params);
}
