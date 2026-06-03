import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/firestore_codec.dart';

/// Firestore wire model for a `subscriptions` document (id == userId).
class SubscriptionDto {
  const SubscriptionDto({
    required this.userId,
    required this.tier,
    required this.status,
    required this.startedAt,
    this.renewsAt,
  });

  final String userId;
  final String tier;
  final String status;
  final DateTime startedAt;
  final DateTime? renewsAt;

  factory SubscriptionDto.fromMap(String id, Map<String, dynamic> map) {
    return SubscriptionDto(
      userId: id,
      tier: FsCodec.asString(map['tier'], 'free'),
      status: FsCodec.asString(map['status'], 'inactive'),
      startedAt: FsCodec.asDate(map['startedAt']),
      renewsAt: FsCodec.asDateOrNull(map['renewsAt']),
    );
  }

  factory SubscriptionDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      SubscriptionDto.fromMap(doc.id, doc.data() ?? const {});

  Map<String, dynamic> toMap() {
    return {
      'tier': tier,
      'status': status,
      'startedAt': FsCodec.toTimestamp(startedAt),
      'renewsAt': renewsAt == null ? null : FsCodec.toTimestamp(renewsAt!),
    };
  }
}
