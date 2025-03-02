import 'dart:convert';

class Rating {
  final String userId;
  final double rating;
  Rating({required this.rating, required this.userId});
  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
        userId: map['userId'] ?? '', rating: map['rating'].toDouble() ?? 0.0);
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
    };
  }

  String toJson() => json.encode(toMap());
  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
}
