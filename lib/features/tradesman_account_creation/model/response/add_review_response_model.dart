class AddReviewResponseModel {
  final String? id;
  final String? reviewer;
  final String? tradesman;
  final int? rating;
  final String? ratingLabel;
  final String? reviewText;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  AddReviewResponseModel({
    this.id,
    this.reviewer,
    this.tradesman,
    this.rating,
    this.ratingLabel,
    this.reviewText,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AddReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return AddReviewResponseModel(
      id: json['_id'],
      reviewer: json['reviewer'],
      tradesman: json['tradesman'],
      rating: json['rating'],
      ratingLabel: json['ratingLabel'],
      reviewText: json['reviewText'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reviewer': reviewer,
      'tradesman': tradesman,
      'rating': rating,
      'ratingLabel': ratingLabel,
      'reviewText': reviewText,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
