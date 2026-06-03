import '../core/result.dart';
import '../core/usecase.dart';
import '../entities/producer.dart';
import '../repositories/producer_repository.dart';

/// Fetches a single producer/cooperative for the Producer Profile screen.
class GetProducerById implements UseCase<Producer, String> {
  const GetProducerById(this._repository);

  final ProducerRepository _repository;

  @override
  Future<Result<Producer>> call(String params) =>
      _repository.getProducerById(params);
}
