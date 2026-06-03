/// Municipality-level geographic coordinate for origin map pins.
///
/// Named [GeoLocation] (not `GeoPoint`) to avoid clashing with Firestore's
/// `GeoPoint`, which lives only in the data layer.
class GeoLocation {
  const GeoLocation({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}
