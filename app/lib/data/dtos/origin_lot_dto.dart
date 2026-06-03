import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/firestore_codec.dart';

/// A timeline step as stored inside an `origin_lots` document's `timeline[]`.
class TimelineEventDto {
  const TimelineEventDto({
    required this.title,
    required this.description,
    required this.date,
  });

  final String title;
  final String description;
  final DateTime date;

  factory TimelineEventDto.fromMap(Map<String, dynamic> map) {
    return TimelineEventDto(
      title: FsCodec.asString(map['title']),
      description: FsCodec.asString(map['description']),
      date: FsCodec.asDate(map['date']),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'date': FsCodec.toTimestamp(date),
      };
}

/// Firestore wire model for an `origin_lots` document.
class OriginLotDto {
  const OriginLotDto({
    required this.id,
    required this.producerId,
    required this.municipality,
    required this.geoLat,
    required this.geoLng,
    required this.harvestDate,
    this.processingNotes = '',
    this.timeline = const [],
  });

  final String id;
  final String producerId;
  final String municipality;
  final double geoLat;
  final double geoLng;
  final DateTime harvestDate;
  final String processingNotes;
  final List<TimelineEventDto> timeline;

  factory OriginLotDto.fromMap(String id, Map<String, dynamic> map) {
    final geo = FsCodec.asGeo(map['geo']);
    final rawTimeline = map['timeline'];
    return OriginLotDto(
      id: id,
      producerId: FsCodec.asString(map['producerId']),
      municipality: FsCodec.asString(map['municipality']),
      geoLat: geo.lat,
      geoLng: geo.lng,
      harvestDate: FsCodec.asDate(map['harvestDate']),
      processingNotes: FsCodec.asString(map['processingNotes']),
      timeline: rawTimeline is List
          ? rawTimeline
              .whereType<Map>()
              .map((e) => TimelineEventDto.fromMap(e.cast<String, dynamic>()))
              .toList()
          : const [],
    );
  }

  factory OriginLotDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      OriginLotDto.fromMap(doc.id, doc.data() ?? const {});

  Map<String, dynamic> toMap() {
    return {
      'producerId': producerId,
      'municipality': municipality,
      'geo': FsCodec.geoToMap(geoLat, geoLng),
      'harvestDate': FsCodec.toTimestamp(harvestDate),
      'processingNotes': processingNotes,
      'timeline': timeline.map((e) => e.toMap()).toList(),
    };
  }
}
