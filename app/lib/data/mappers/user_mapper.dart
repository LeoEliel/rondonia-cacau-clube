import '../../domain/entities/enums.dart';
import '../../domain/entities/user.dart';
import '../dtos/user_dto.dart';

/// Converts between [UserDto] and [User].
class UserMapper {
  const UserMapper();

  User toEntity(UserDto dto) {
    return User(
      uid: dto.uid,
      name: dto.name,
      email: dto.email,
      photoUrl: dto.photoUrl,
      subscriptionTier: SubscriptionTier.fromWire(dto.subscriptionTier),
      followingProducerIds: dto.followingProducerIds,
      createdAt: dto.createdAt,
    );
  }

  UserDto toDto(User e) {
    return UserDto(
      uid: e.uid,
      name: e.name,
      email: e.email,
      photoUrl: e.photoUrl,
      subscriptionTier: e.subscriptionTier.wireKey,
      followingProducerIds: e.followingProducerIds,
      createdAt: e.createdAt,
    );
  }
}
