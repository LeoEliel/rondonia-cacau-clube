import '../../domain/entities/enums.dart';
import '../../domain/entities/subscription.dart';
import '../dtos/subscription_dto.dart';

/// Converts between [SubscriptionDto] and [Subscription].
class SubscriptionMapper {
  const SubscriptionMapper();

  Subscription toEntity(SubscriptionDto dto) {
    return Subscription(
      userId: dto.userId,
      tier: SubscriptionTier.fromWire(dto.tier),
      status: SubscriptionStatus.fromWire(dto.status),
      startedAt: dto.startedAt,
      renewsAt: dto.renewsAt,
    );
  }

  SubscriptionDto toDto(Subscription e) {
    return SubscriptionDto(
      userId: e.userId,
      tier: e.tier.wireKey,
      status: e.status.wireKey,
      startedAt: e.startedAt,
      renewsAt: e.renewsAt,
    );
  }
}
