import 'geo_location.dart';
import 'timeline_event.dart';

/// Origin / traceability record for a harvest lot
/// (the `origin_lots` Firestore collection).
class OriginLot {
  const OriginLot({
    required this.id,
    required this.producerId,
    required this.municipality,
    required this.geo,
    required this.harvestDate,
    this.processingNotes = '',
    this.timeline = const [],
  });

  final String id;
  final String producerId;
  final String municipality;
  final GeoLocation geo;
  final DateTime harvestDate;
  final String processingNotes;

  /// Ordered farm-to-product steps.
  final List<TimelineEvent> timeline;
}
