import '../core/result.dart';
import '../entities/producer.dart';

/// Read access to producers and cooperatives.
abstract interface class ProducerRepository {
  Future<Result<List<Producer>>> getProducers();

  Future<Result<Producer>> getProducerById(String id);
}
