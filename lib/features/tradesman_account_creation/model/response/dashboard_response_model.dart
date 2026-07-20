class TradesmanDashboardResponse {
  final Profile? profile;
  final int? viewsThisWeek;
  final int? tradesListed;
  final num? overallRating;
  final int? reviewsTotal;
  final Verification? verification;
  final List<RatingBreakdown>? ratingBreakdown;
  final List<RecentReview>? recentReviews;
  final int? daysOnPlatform;

  TradesmanDashboardResponse({
    this.profile,
    this.viewsThisWeek,
    this.verification,
    this.tradesListed,
    this.overallRating,
    this.reviewsTotal,
    this.ratingBreakdown,
    this.recentReviews,
    this.daysOnPlatform,
  });

  factory TradesmanDashboardResponse.fromJson(Map<String, dynamic> json) {
    final profileJson = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'])
        : json.containsKey('_id') || json.containsKey('mainSkill')
        ? json
        : null;

    return TradesmanDashboardResponse(
      profile: profileJson != null ? Profile.fromJson(profileJson) : null,
      viewsThisWeek: json['viewsThisWeek'],
      tradesListed: json['tradesListed'],
      overallRating: json['overallRating'],
      reviewsTotal: json['reviewsTotal'],
      verification: json['verification'] != null
          ? Verification.fromJson(json['verification'])
          : null,
      ratingBreakdown: (json['ratingBreakdown'] as List?)
          ?.map((e) => RatingBreakdown.fromJson(e))
          .toList(),
      recentReviews: (json['recentReviews'] as List?)
          ?.map((e) => RecentReview.fromJson(e))
          .toList(),
      daysOnPlatform: json['daysOnPlatform'],
    );
  }
}

class Profile {
  final String? id;
  final User? user;
  final TypicalRate? typicalRate;
  final ContactChangeRequest? contactChangeRequest;
  final List<dynamic>? profileViews;
  final List<String>? extraSkills;
  final String? pitch;
  final String? verificationStatus;
  final bool? isLive;
  final bool? isVip;
  final num? ratingAverage;
  final int? ratingCount;
  final int? jobsCount;
  final List<WorkPhoto>? workPhotos;
  final String? mainSkill;
  final String? homeArea;
  final String? travelRange;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Profile({
    this.id,
    this.user,
    this.typicalRate,
    this.contactChangeRequest,
    this.profileViews,
    this.extraSkills,
    this.pitch,
    this.verificationStatus,
    this.isLive,
    this.isVip,
    this.ratingAverage,
    this.ratingCount,
    this.jobsCount,
    this.workPhotos,
    this.mainSkill,
    this.homeArea,
    this.travelRange,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      typicalRate: json['typicalRate'] != null
          ? TypicalRate.fromJson(json['typicalRate'])
          : null,
      contactChangeRequest: json['contactChangeRequest'] != null
          ? ContactChangeRequest.fromJson(json['contactChangeRequest'])
          : null,
      profileViews: json['profileViews'] ?? [],
      extraSkills: List<String>.from(json['extraSkills'] ?? []),
      pitch: json['pitch'],
      verificationStatus: json['verificationStatus'],
      isLive: json['isLive'],
      isVip: json['isVip'],
      ratingAverage: json['ratingAverage'],
      ratingCount: json['ratingCount'],
      jobsCount: json['jobsCount'],
      workPhotos: (json['workPhotos'] as List?)
          ?.map((e) => WorkPhoto.fromJson(e))
          .toList(),
      mainSkill: json['mainSkill'],
      homeArea: json['homeArea'],
      travelRange: json['travelRange'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}

class User {
  final String? id;
  final String? area;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? phoneNumber;
  final String? createdAt;
  final ProfileImage? profileImage;

  User({
    this.id,
    this.area,
    this.firstName,
    this.lastName,
    this.name,
    this.phoneNumber,
    this.createdAt,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      area: json['area'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'],
      profileImage: json['profileImage'] != null
          ? ProfileImage.fromJson(json['profileImage'])
          : null,
    );
  }
}

class RecentReview {
  final String? reviewerName;
  final int? rating;
  final String? comment;
  final String? createdAt;

  RecentReview({this.reviewerName, this.rating, this.comment, this.createdAt});

  factory RecentReview.fromJson(dynamic value) {
    if (value is! Map) return RecentReview();

    final json = Map<String, dynamic>.from(value);
    final reviewer = json['reviewer'] ?? json['user'] ?? json['client'];
    final reviewerMap = reviewer is Map
        ? Map<String, dynamic>.from(reviewer)
        : null;
    final firstName = reviewerMap?['firstName']?.toString().trim() ?? '';
    final lastName = reviewerMap?['lastName']?.toString().trim() ?? '';
    final name = reviewerMap?['name']?.toString().trim();
    final reviewerName = (name != null && name.isNotEmpty)
        ? name
        : [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

    return RecentReview(
      reviewerName: reviewerName.isNotEmpty
          ? reviewerName
          : json['reviewerName']?.toString(),
      rating: (json['rating'] as num?)?.toInt(),
      comment: json['comment']?.toString() ?? json['review']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}

class ProfileImage {
  final String? publicId;
  final String? url;

  ProfileImage({this.publicId, this.url});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(publicId: json['public_id'], url: json['url']);
  }
}

class ContactChangeRequest {
  final String? requestedName;
  final String? requestedPhoneNumber;
  final String? reason;
  final String? status;
  final String? requestedAt;

  ContactChangeRequest({
    this.requestedName,
    this.requestedPhoneNumber,
    this.reason,
    this.status,
    this.requestedAt,
  });

  factory ContactChangeRequest.fromJson(Map<String, dynamic> json) {
    return ContactChangeRequest(
      requestedName: json['requestedName'],
      requestedPhoneNumber: json['requestedPhoneNumber'],
      reason: json['reason'],
      status: json['status'],
      requestedAt: json['requestedAt'],
    );
  }
}

class TypicalRate {
  final num? amount;
  final String? unit;

  TypicalRate({this.amount, this.unit});

  factory TypicalRate.fromJson(Map<String, dynamic> json) {
    return TypicalRate(amount: json['amount'], unit: json['unit']);
  }
}

class Verification {
  final String? status;
  final String? label;

  Verification({this.status, this.label});

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(status: json['status'], label: json['label']);
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'label': label};
  }
}

class WorkPhoto {
  final String? id;
  final String? publicId;
  final String? url;

  WorkPhoto({this.id, this.publicId, this.url});

  factory WorkPhoto.fromJson(Map<String, dynamic> json) {
    return WorkPhoto(
      id: json['_id'],
      publicId: json['public_id'],
      url: json['url'],
    );
  }
}

class RatingBreakdown {
  final int? star;
  final int? count;

  RatingBreakdown({this.star, this.count});

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) {
    return RatingBreakdown(star: json['star'], count: json['count']);
  }
}
