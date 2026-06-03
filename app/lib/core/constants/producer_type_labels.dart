import '../../domain/entities/enums.dart';

/// pt-BR display label for a [ProducerType] (e.g. the "COOPERATIVA" overline on
/// the producer link card). Keeps UI copy out of the domain enum.
extension ProducerTypeLabel on ProducerType {
  String get label => switch (this) {
        ProducerType.cooperative => 'Cooperativa',
        ProducerType.producer => 'Produtor',
      };
}
