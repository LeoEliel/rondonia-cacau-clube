import '../../domain/entities/geo_location.dart';
import '../../domain/entities/origin_lot.dart';
import '../../domain/entities/timeline_event.dart';
import '../dtos/origin_lot_dto.dart';

/// Converts between [OriginLotDto] and [OriginLot] (including its timeline).
class OriginLotMapper {
  const OriginLotMapper();

  OriginLot toEntity(OriginLotDto dto) {
    return OriginLot(
      id: dto.id,
      producerId: dto.producerId,
      municipality: dto.municipality,
      geo: GeoLocation(latitude: dto.geoLat, longitude: dto.geoLng),
      harvestDate: dto.harvestDate,
      processingNotes: dto.processingNotes,
      timeline: dto.timeline
          .map((e) => TimelineEvent(
                title: e.title,
                description: e.description,
                date: e.date,
              ))
          .toList(),
    );
  }

  OriginLotDto toDto(OriginLot e) {
    return OriginLotDto(
      id: e.id,
      producerId: e.producerId,
      municipality: e.municipality,
      geoLat: e.geo.latitude,
      geoLng: e.geo.longitude,
      harvestDate: e.harvestDate,
      processingNotes: e.processingNotes,
      timeline: e.timeline
          .map((t) => TimelineEventDto(
                title: t.title,
                description: t.description,
                date: t.date,
              ))
          .toList(),
    );
  }
}
