import '../../domain/entities/enums.dart';
import '../../domain/entities/geo_location.dart';
import '../../domain/entities/producer.dart';
import '../dtos/producer_dto.dart';

/// Converts between [ProducerDto] and [Producer].
class ProducerMapper {
  const ProducerMapper();

  Producer toEntity(ProducerDto dto) {
    return Producer(
      id: dto.id,
      name: dto.name,
      type: ProducerType.fromWire(dto.type),
      bio: dto.bio,
      story: dto.story,
      municipality: dto.municipality,
      geo: GeoLocation(latitude: dto.geoLat, longitude: dto.geoLng),
      certifications: dto.certifications,
      qualitySeals: dto.qualitySeals
          .map(QualitySeal.fromWire)
          .whereType<QualitySeal>()
          .toList(),
      photoUrls: dto.photoUrls,
      followerCount: dto.followerCount,
      rating: dto.rating,
    );
  }

  ProducerDto toDto(Producer e) {
    return ProducerDto(
      id: e.id,
      name: e.name,
      type: e.type.wireKey,
      bio: e.bio,
      story: e.story,
      municipality: e.municipality,
      geoLat: e.geo.latitude,
      geoLng: e.geo.longitude,
      certifications: e.certifications,
      qualitySeals: e.qualitySeals.map((s) => s.wireKey).toList(),
      photoUrls: e.photoUrls,
      followerCount: e.followerCount,
      rating: e.rating,
    );
  }
}
