import '../../domain/entities/enums.dart';

/// pt-BR display labels for [ProductSort] (shown as the results sort control on
/// the Search screen). Keeps UI copy out of the domain enum.
extension ProductSortLabel on ProductSort {
  String get label => switch (this) {
        ProductSort.recent => 'Mais recentes',
        ProductSort.topRated => 'Mais bem avaliados',
        ProductSort.nameAsc => 'Nome A–Z',
      };
}
