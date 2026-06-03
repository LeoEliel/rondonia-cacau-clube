import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/firestore_codec.dart';

/// Firestore wire model for a `users` document.
class UserDto {
  const UserDto({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.subscriptionTier = 'free',
    this.followingProducerIds = const [],
    required this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String subscriptionTier;
  final List<String> followingProducerIds;
  final DateTime createdAt;

  factory UserDto.fromMap(String id, Map<String, dynamic> map) {
    return UserDto(
      uid: id,
      name: FsCodec.asString(map['name']),
      email: FsCodec.asString(map['email']),
      photoUrl: FsCodec.asStringOrNull(map['photoUrl']),
      subscriptionTier: FsCodec.asString(map['subscriptionTier'], 'free'),
      followingProducerIds: FsCodec.asStringList(map['followingProducerIds']),
      createdAt: FsCodec.asDate(map['createdAt']),
    );
  }

  factory UserDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      UserDto.fromMap(doc.id, doc.data() ?? const {});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'subscriptionTier': subscriptionTier,
      'followingProducerIds': followingProducerIds,
      'createdAt': FsCodec.toTimestamp(createdAt),
    };
  }
}
