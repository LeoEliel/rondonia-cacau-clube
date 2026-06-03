import 'enums.dart';

/// A consumer of the app (the `users` Firestore collection).
///
/// Auth wiring (Firebase Auth) arrives in a later milestone; for now this
/// entity models the persisted user profile. When Firebase Auth is introduced,
/// its `User` type will be imported with a prefix to avoid the name clash.
class User {
  const User({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.subscriptionTier = SubscriptionTier.free,
    this.followingProducerIds = const [],
    required this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final SubscriptionTier subscriptionTier;
  final List<String> followingProducerIds;
  final DateTime createdAt;

  bool get isClubMember => subscriptionTier == SubscriptionTier.paid;

  bool isFollowing(String producerId) =>
      followingProducerIds.contains(producerId);

  User copyWith({
    String? name,
    String? email,
    String? photoUrl,
    SubscriptionTier? subscriptionTier,
    List<String>? followingProducerIds,
  }) {
    return User(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      followingProducerIds: followingProducerIds ?? this.followingProducerIds,
      createdAt: createdAt,
    );
  }
}
