import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/firestore_codec.dart';

/// Firestore wire model for a `producers` document.
class ProducerDto {
  const ProducerDto({
    required this.id,
    required this.name,
    required this.type,
    required this.bio,
    required this.story,
    required this.municipality,
    required this.geoLat,
    required this.geoLng,
    this.certifications = const [],
    this.qualitySeals = const [],
    this.photoUrls = const [],
    this.followerCount = 0,
    this.rating = 0,
  });

  final String id;
  final String name;
  final String type;
  final String bio;
  final String story;
  final String municipality;
  final double geoLat;
  final double geoLng;
  final List<String> certifications;
  final List<String> qualitySeals;
  final List<String> photoUrls;
  final int followerCount;
  final double rating;

  factory ProducerDto.fromMap(String id, Map<String, dynamic> map) {
    final geo = FsCodec.asGeo(map['geo']);
    return ProducerDto(
      id: id,
      name: FsCodec.asString(map['name']),
      type: FsCodec.asString(map['type'], 'producer'),
      bio: FsCodec.asString(map['bio']),
      story: FsCodec.asString(map['story']),
      municipality: FsCodec.asString(map['municipality']),
      geoLat: geo.lat,
      geoLng: geo.lng,
      certifications: FsCodec.asStringList(map['certifications']),
      qualitySeals: FsCodec.asStringList(map['qualitySeals']),
      photoUrls: FsCodec.asStringList(map['photoUrls']),
      followerCount: FsCodec.asInt(map['followerCount']),
      rating: FsCodec.asDouble(map['rating']),
    );
  }

  factory ProducerDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ProducerDto.fromMap(doc.id, doc.data() ?? const {});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'bio': bio,
      'story': story,
      'municipality': municipality,
      'geo': FsCodec.geoToMap(geoLat, geoLng),
      'certifications': certifications,
      'qualitySeals': qualitySeals,
      'photoUrls': photoUrls,
      'followerCount': followerCount,
      'rating': rating,
    };
  }
}
