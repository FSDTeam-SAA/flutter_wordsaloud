import 'package:aturservicett/features/tradesman_account_creation/model/response/dashboard_response_model.dart'
    as dashboard;
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_specific_tradesman_response_model.dart'
    as details;
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_all_tradesman_response_model.dart'
    as browse;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final reviews = [
    {'_id': 'approved', 'moderationStatus': 'approved', 'reviewText': 'Public'},
    {'_id': 'rejected', 'moderationStatus': 'rejected', 'reviewText': 'Hidden'},
    {'_id': 'pending', 'moderationStatus': 'pending'},
    {'_id': 'legacy', 'reviewText': 'Legacy'},
    {'_id': 'unknown', 'moderationStatus': 'unknown'},
    {'_id': 'null', 'moderationStatus': null},
  ];

  test('customer review envelopes follow backend moderation visibility', () {
    for (final payload in [
      {'profile': <String, dynamic>{}, 'reviews': reviews},
      {
        'reviews': {'data': reviews},
      },
      {
        'reviews': {'items': reviews},
      },
      {
        'reviews': {'docs': reviews},
      },
      {
        'profile': {'reviews': reviews},
      },
    ]) {
      final model = details.GetSpecificTradesmanResponseModel.fromJson(payload);
      expect(model.reviews.map((review) => review.id), ['approved', 'legacy']);
    }
  });

  test('owner dashboard applies the same moderation filter', () {
    final model = dashboard.TradesmanDashboardResponse.fromJson({
      'recentReviews': reviews,
    });
    expect(model.recentReviews!.map((review) => review.comment), [
      'Public',
      'Legacy',
    ]);
  });

  test('a rejected review and zero total stay hidden and zero in details', () {
    final model = details.GetSpecificTradesmanResponseModel.fromJson({
      'profile': {'ratingCount': 0, 'ratingAverage': 0},
      'reviews': [reviews[1]],
    });
    expect(model.reviews, isEmpty);
    expect(model.profile.ratingCount, 0);
    expect(model.profile.ratingAverage, 0);
  });

  test('browse cards preserve explicit zero counts despite a review array', () {
    final model = browse.Tradesman.fromJson({
      'ratingCount': 0,
      'reviews': reviews,
    });
    expect(model.ratingCount, 0);
  });

  test(
    'legacy browse responses count only visible reviews when no total exists',
    () {
      final model = browse.Tradesman.fromJson({'reviews': reviews});
      expect(model.ratingCount, 2);
    },
  );

  test('server totals are preserved when the review list is paginated', () {
    final model = details.GetSpecificTradesmanResponseModel.fromJson({
      'profile': {'ratingCount': 30},
      'reviews': [reviews[0]],
    });
    expect(model.profile.ratingCount, 30);
    expect(model.reviews, hasLength(1));
  });
}
