import '../../domain/entities/enums.dart';

/// pt-BR display labels for [ByproductCategory] and the ordered list of
/// categories surfaced as catalog filter chips. Keeps UI copy out of the domain
/// while staying a single source of truth for the presentation layer.
extension ByproductCategoryLabel on ByproductCategory {
  String get label => switch (this) {
        ByproductCategory.cocoaHoney => 'Mel de cacau',
        ByproductCategory.nibs => 'Nibs',
        ByproductCategory.butter => 'Manteiga',
        ByproductCategory.powder => 'Pó',
        ByproductCategory.pulp => 'Polpa',
        ByproductCategory.jelly => 'Geleia',
        ByproductCategory.liqueur => 'Licor',
        ByproductCategory.biomass => 'Biomassa',
        ByproductCategory.cosmetic => 'Cosmético',
        ByproductCategory.huskCoffee => 'Café de casca',
        ByproductCategory.chocolate => 'Chocolate',
        ByproductCategory.other => 'Outros',
      };
}

/// Categories shown as filter chips on the catalog, in display order
/// (weighted: cocoa honey + nibs first). `Todos` (all) is handled separately
/// as a `null` selection.
const List<ByproductCategory> kCatalogCategories = [
  ByproductCategory.cocoaHoney,
  ByproductCategory.nibs,
  ByproductCategory.butter,
  ByproductCategory.powder,
  ByproductCategory.pulp,
  ByproductCategory.jelly,
  ByproductCategory.liqueur,
  ByproductCategory.cosmetic,
  ByproductCategory.huskCoffee,
  ByproductCategory.chocolate,
];
