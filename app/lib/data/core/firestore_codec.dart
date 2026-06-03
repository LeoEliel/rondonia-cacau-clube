import 'package:cloud_firestore/cloud_firestore.dart';

/// Small, defensive helpers for reading/writing Firestore field values.
///
/// Firestore returns dynamically-typed maps; these keep DTO `fromMap`/`toMap`
/// concise and tolerant of missing or differently-typed fields (e.g. an `int`
/// stored where a `double` is expected).
abstract final class FsCodec {
  FsCodec._();

  static String asString(Object? v, [String fallback = '']) =>
      v is String ? v : fallback;

  static String? asStringOrNull(Object? v) => v is String ? v : null;

  static double asDouble(Object? v, [double fallback = 0]) =>
      v is num ? v.toDouble() : fallback;

  static int asInt(Object? v, [int fallback = 0]) =>
      v is num ? v.toInt() : fallback;

  static List<String> asStringList(Object? v) =>
      v is List ? v.whereType<String>().toList() : const [];

  /// Firestore [Timestamp] → [DateTime] (epoch fallback if absent/invalid).
  static DateTime asDate(Object? v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? asDateOrNull(Object? v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  static Timestamp toTimestamp(DateTime d) => Timestamp.fromDate(d);

  /// Reads a `{ "lat": .., "lng": .. }` map into a (lat, lng) record.
  static ({double lat, double lng}) asGeo(Object? v) {
    if (v is Map) {
      return (lat: asDouble(v['lat']), lng: asDouble(v['lng']));
    }
    return (lat: 0, lng: 0);
  }

  static Map<String, double> geoToMap(double lat, double lng) =>
      {'lat': lat, 'lng': lng};
}
