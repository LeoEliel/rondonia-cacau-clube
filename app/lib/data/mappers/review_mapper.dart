import '../../domain/entities/review.dart';
import '../dtos/review_dto.dart';

/// Converts between [ReviewDto] and [Review].
class ReviewMapper {
  const ReviewMapper();

  Review toEntity(ReviewDto dto) {
    return Review(
      id: dto.id,
      productId: dto.productId,
      userId: dto.userId,
      rating: dto.rating,
      text: dto.text,
      createdAt: dto.createdAt,
      userName: dto.userName,
      userPhotoUrl: dto.userPhotoUrl,
    );
  }

  ReviewDto toDto(Review e) {
    return ReviewDto(
      id: e.id,
      productId: e.productId,
      userId: e.userId,
      rating: e.rating,
      text: e.text,
      createdAt: e.createdAt,
      userName: e.userName,
      userPhotoUrl: e.userPhotoUrl,
    );
  }
}
