import '../../domain/core/failure.dart';
import '../../domain/core/result.dart';
import '../../domain/entities/producer.dart';
import '../../domain/repositories/producer_repository.dart';
import '../mappers/producer_mapper.dart';
import '../../seed/mock_data.dart';

/// Offline [ProducerRepository] backed by [MockData] (demo mode).
class InMemoryProducerRepository implements ProducerRepository {
  final ProducerMapper _mapper = const ProducerMapper();

  List<Producer> get _all => MockData.producers.map(_mapper.toEntity).toList();

  @override
  Future<Result<List<Producer>>> getProducers() async {
    final items = _all
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return success(items);
  }

  @override
  Future<Result<Producer>> getProducerById(String id) async {
    final match = _all.where((p) => p.id == id);
    return match.isEmpty
        ? failure(NotFoundFailure('Produtor "$id" não encontrado.'))
        : success(match.first);
  }
}
