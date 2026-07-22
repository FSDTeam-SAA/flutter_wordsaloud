class AddReviewRequestModel {
  final int rating;
  final String ratingLabel;
  final String reviewText;

  AddReviewRequestModel({
    required this.rating,
    required this.ratingLabel,
    required this.reviewText,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'ratingLabel': ratingLabel,
      'reviewText': reviewText,
    };
  }
}
