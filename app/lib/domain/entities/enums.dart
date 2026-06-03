// Shared domain enums. Pure Dart: each carries a stable `wireKey` used for
// Firestore (de)serialization, decoupling the persisted strings from the Dart
// names so renaming an enum value never breaks stored data.

/// Whether an origin is an individual producer or a cooperative.
enum ProducerType {
  producer('producer'),
  cooperative('cooperative');

  const ProducerType(this.wireKey);
  final String wireKey;

  static ProducerType fromWire(String? key) => values.firstWhere(
        (e) => e.wireKey == key,
        orElse: () => ProducerType.producer,
      );
}

/// Cocoa byproduct category. The catalog is weighted toward [cocoaHoney] and
/// [nibs]; [chocolate] is included but de-emphasized (this is a byproducts app).
enum ByproductCategory {
  cocoaHoney('cocoa_honey'),
  nibs('nibs'),
  butter('butter'),
  powder('powder'),
  pulp('pulp'),
  jelly('jelly'),
  liqueur('liqueur'),
  biomass('biomass'),
  cosmetic('cosmetic'),
  huskCoffee('husk_coffee'),
  chocolate('chocolate'),
  other('other');

  const ByproductCategory(this.wireKey);
  final String wireKey;

  static ByproductCategory fromWire(String? key) => values.firstWhere(
        (e) => e.wireKey == key,
        orElse: () => ByproductCategory.other,
      );
}

/// Quality seals / badges shown on products and producers.
///
/// Single source of truth for the seal identity (the presentation layer's
/// `SealStyle` map keys off this enum). Returns `null` for unknown keys so
/// mappers can skip values they don't recognize.
enum QualitySeal {
  cacauFino('cacau_fino'),
  origemRO('origem_ro'),
  organico('organico'),
  agrofloresta('agrofloresta'),
  comercioJusto('comercio_justo');

  const QualitySeal(this.wireKey);
  final String wireKey;

  static QualitySeal? fromWire(String? key) {
    for (final seal in values) {
      if (seal.wireKey == key) return seal;
    }
    return null;
  }
}

/// Cocoa Club subscription tier. Paid state is mocked in this prototype.
enum SubscriptionTier {
  free('free'),
  paid('paid');

  const SubscriptionTier(this.wireKey);
  final String wireKey;

  static SubscriptionTier fromWire(String? key) => values.firstWhere(
        (e) => e.wireKey == key,
        orElse: () => SubscriptionTier.free,
      );
}

/// Lifecycle of a subscription record.
enum SubscriptionStatus {
  active('active'),
  inactive('inactive'),
  canceled('canceled');

  const SubscriptionStatus(this.wireKey);
  final String wireKey;

  static SubscriptionStatus fromWire(String? key) => values.firstWhere(
        (e) => e.wireKey == key,
        orElse: () => SubscriptionStatus.inactive,
      );
}

/// Sort order for catalog queries.
enum ProductSort {
  recent('recent'),
  topRated('top_rated'),
  nameAsc('name_asc');

  const ProductSort(this.wireKey);
  final String wireKey;
}
