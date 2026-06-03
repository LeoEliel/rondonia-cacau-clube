/// A user's rating + text review of a product (the `reviews` collection).
///
/// [userName] / [userPhotoUrl] are denormalized copies of the author's profile
/// so the reviews list can render without a second lookup — a common Firestore
/// modeling choice for read-heavy screens.
class Review {
  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.text,
    required this.createdAt,
    this.userName,
    this.userPhotoUrl,
  });

  final String id;
  final String productId;
  final String userId;

  /// Star rating, 1–5.
  final int rating;
  final String text;
  final DateTime createdAt;
  final String? userName;
  final String? userPhotoUrl;
}
