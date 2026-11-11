// Match the backend's visibleReviews filter, including legacy reviews.
bool isVisibleReview(Map review) =>
    !review.containsKey('moderationStatus') ||
    review['moderationStatus'] == 'approved';
