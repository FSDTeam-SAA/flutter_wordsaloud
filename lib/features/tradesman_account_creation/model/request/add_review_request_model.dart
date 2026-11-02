class AddReviewRequestModel {
  final String skill;
  final int rating;
  final String ratingLabel;
  final String reviewText;

  AddReviewRequestModel({
    required this.skill,
    required this.rating,
    required this.ratingLabel,
    required this.reviewText,
  });

  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'rating': rating,
      'ratingLabel': ratingLabel,
      'reviewText': reviewText,
    };
  }
}
