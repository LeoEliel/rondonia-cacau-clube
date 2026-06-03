import 'enums.dart';
import 'geo_location.dart';

/// A producer or cooperative of Rondônia cocoa byproducts
/// (the `producers` Firestore collection).
class Producer {
  const Producer({
    required this.id,
    required this.name,
    required this.type,
    required this.bio,
    required this.story,
    required this.municipality,
    required this.geo,
    this.certifications = const [],
    this.qualitySeals = const [],
    this.photoUrls = const [],
    this.followerCount = 0,
    this.rating = 0,
  });

  final String id;
  final String name;
  final ProducerType type;

  /// Short bio / tagline.
  final String bio;

  /// Long-form story (rendered in the italic "story" type style).
  final String story;

  /// Municipality in Rondônia (e.g. Ariquemes, Ji-Paraná).
  final String municipality;
  final GeoLocation geo;

  /// Free-form certification names (e.g. "Certificação Orgânica IBD").
  final List<String> certifications;
  final List<QualitySeal> qualitySeals;
  final List<String> photoUrls;
  final int followerCount;

  /// Aggregate rating (0–5).
  final double rating;

  bool get isCooperative => type == ProducerType.cooperative;

  String? get coverPhotoUrl => photoUrls.isNotEmpty ? photoUrls.first : null;
}
