import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/firestore_codec.dart';

/// Firestore wire model for a `reviews` document.
class ReviewDto {
  const ReviewDto({
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
  final int rating;
  final String text;
  final DateTime createdAt;
  final String? userName;
  final String? userPhotoUrl;

  factory ReviewDto.fromMap(String id, Map<String, dynamic> map) {
    return ReviewDto(
      id: id,
      productId: FsCodec.asString(map['productId']),
      userId: FsCodec.asString(map['userId']),
      rating: FsCodec.asInt(map['rating']),
      text: FsCodec.asString(map['text']),
      createdAt: FsCodec.asDate(map['createdAt']),
      userName: FsCodec.asStringOrNull(map['userName']),
      userPhotoUrl: FsCodec.asStringOrNull(map['userPhotoUrl']),
    );
  }

  factory ReviewDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ReviewDto.fromMap(doc.id, doc.data() ?? const {});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'rating': rating,
      'text': text,
      'createdAt': FsCodec.toTimestamp(createdAt),
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  ReviewDto copyWith({String? id}) => ReviewDto(
        id: id ?? this.id,
        productId: productId,
        userId: userId,
        rating: rating,
        text: text,
        createdAt: createdAt,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
      );
}
