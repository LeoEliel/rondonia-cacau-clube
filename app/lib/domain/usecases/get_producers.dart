import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/producer.dart';
import '../repositories/producer_repository.dart';

/// Lists all producers and cooperatives.
class GetProducers implements UseCase<List<Producer>, NoParams> {
  const GetProducers(this._repository);

  final ProducerRepository _repository;

  @override
  Future<Result<List<Producer>>> call(NoParams params) =>
      _repository.getProducers();
}
