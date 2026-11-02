import 'package:flutter_test/flutter_test.dart';
import 'package:aturservicett/core/network/constants/api_constants.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/request/add_review_request_model.dart';

void main() {
  test('reviews post the selected extra skill rather than the main skill', () {
    final request = AddReviewRequestModel(
      skill: 'Welder/Gate',
      rating: 5,
      ratingLabel: 'Excellent',
      reviewText: 'Great gate repair',
    );
    expect(request.toJson()['skill'], 'Welder/Gate');
  });

  test('detail requests isolate reviews and ratings by selected category', () {
    for (final skill in ['Plumber', 'Welder/Gate', 'Computer Tech']) {
      final url = Uri.parse(
        ApiConstants.user.tradesmanDetails('profile-id', skill: skill),
      );
      expect(url.path, '/api/v1/tradesman/profile-id');
      expect(url.queryParameters, {'skill': skill});
    }
  });
}
