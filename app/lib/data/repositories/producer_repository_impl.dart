import '../../domain/core/result.dart';
import '../../domain/entities/producer.dart';
import '../../domain/repositories/producer_repository.dart';
import '../core/firestore_guard.dart';
import '../datasources/producer_remote_data_source.dart';
import '../mappers/producer_mapper.dart';

/// [ProducerRepository] backed by Firestore.
class ProducerRepositoryImpl implements ProducerRepository {
  ProducerRepositoryImpl(this._ds);

  final ProducerRemoteDataSource _ds;
  final ProducerMapper _mapper = const ProducerMapper();

  @override
  Future<Result<List<Producer>>> getProducers() {
    return guardFirestore(() async {
      final dtos = await _ds.fetchProducers();
      return dtos.map(_mapper.toEntity).toList();
    });
  }

  @override
  Future<Result<Producer>> getProducerById(String id) {
    return guardFirestore(() async => _mapper.toEntity(
          await _ds.fetchProducerById(id),
        ));
  }
}
