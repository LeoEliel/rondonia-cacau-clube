/// Firestore collection names — single source of truth so data sources and the
/// seeder can never drift apart on a string literal.
abstract final class FirestorePaths {
  FirestorePaths._();

  static const String users = 'users';
  static const String producers = 'producers';
  static const String products = 'products';
  static const String originLots = 'origin_lots';
  static const String reviews = 'reviews';
  static const String subscriptions = 'subscriptions';
}
