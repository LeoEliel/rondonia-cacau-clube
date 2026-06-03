// Exceptions thrown inside the data layer and translated into domain
// `Failure`s by `guardFirestore`. They never escape the data layer.

/// A requested document did not exist.
class DataNotFoundException implements Exception {
  const DataNotFoundException([this.message = 'Documento não encontrado.']);
  final String message;

  @override
  String toString() => 'DataNotFoundException($message)';
}
