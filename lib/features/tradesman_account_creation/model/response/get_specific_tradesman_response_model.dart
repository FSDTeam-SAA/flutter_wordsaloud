class GetSpecificTradesmanResponseModel {
  final Profile profile;
  final List<Review> reviews;

  GetSpecificTradesmanResponseModel({
    required this.profile,
    required this.reviews,
  });

  factory GetSpecificTradesmanResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final profileJson = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'])
        : json;
    final rawReviews = _extractReviews(json);

    return GetSpecificTradesmanResponseModel(
      profile: Profile.fromJson(profileJson),
      reviews: rawReviews
          .whereType<Map>()
          .map((e) => Review.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  factory GetSpecificTradesmanResponseModel.fromData(dynamic data) {
    if (data is Map) {
      return GetSpecificTradesmanResponseModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    }

    return GetSpecificTradesmanResponseModel(
      profile: Profile.fromJson({}),
      reviews: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}

class Profile {
  final TypicalRate typicalRate;
  final ContactChangeRequest contactChangeRequest;
  final String id;
  final User user;
  final List<String> extraSkills;
  final String pitch;
  final String verificationStatus;
  final bool isLive;
  final bool isVip;
  final num ratingAverage;
  final int ratingCount;
  final int jobsCount;
  final List<dynamic> workPhotos;
  final String mainSkill;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String homeArea;
  final String travelRange;

  Profile({
    required this.typicalRate,
    required this.contactChangeRequest,
    required this.id,
    required this.user,
    required this.extraSkills,
    required this.pitch,
    required this.verificationStatus,
    required this.isLive,
    required this.isVip,
    required this.ratingAverage,
    required this.ratingCount,
    required this.jobsCount,
    required this.workPhotos,
    required this.mainSkill,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.homeArea,
    required this.travelRange,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      typicalRate: TypicalRate.fromJson(
        json['typicalRate'] is Map
            ? Map<String, dynamic>.from(json['typicalRate'])
            : {},
      ),
      contactChangeRequest: ContactChangeRequest.fromJson(
        json['contactChangeRequest'] is Map
            ? Map<String, dynamic>.from(json['contactChangeRequest'])
            : {},
      ),
      id: json['_id']?.toString() ?? '',
      user: User.fromJson(
        json['user'] is Map ? Map<String, dynamic>.from(json['user']) : {},
      ),
      extraSkills: _extraSkillsFromJson(json),
      pitch: json['pitch']?.toString() ?? '',
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      isLive: json['isLive'] == true,
      isVip: json['isVip'] == true,
      ratingAverage: json['ratingAverage'] is num ? json['ratingAverage'] : 0,
      ratingCount: _intFromAny(
        json['ratingCount'] ??
            json['reviewCount'] ??
            json['reviewsCount'] ??
            json['totalReviews'] ??
            json['reviewsTotal'],
      ),
      jobsCount: (json['jobsCount'] as num?)?.toInt() ?? 0,
      workPhotos: List<dynamic>.from(json['workPhotos'] ?? const []),
      mainSkill: json['mainSkill']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      v: (json['__v'] as num?)?.toInt() ?? 0,
      homeArea: json['homeArea']?.toString() ?? '',
      travelRange: json['travelRange']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typicalRate': typicalRate.toJson(),
      'contactChangeRequest': contactChangeRequest.toJson(),
      '_id': id,
      'user': user.toJson(),
      'extraSkills': extraSkills,
      'pitch': pitch,
      'verificationStatus': verificationStatus,
      'isLive': isLive,
      'isVip': isVip,
      'ratingAverage': ratingAverage,
      'ratingCount': ratingCount,
      'jobsCount': jobsCount,
      'workPhotos': workPhotos,
      'mainSkill': mainSkill,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'homeArea': homeArea,
      'travelRange': travelRange,
    };
  }
}

List _extractReviews(Map<String, dynamic> json) {
  final reviews = json['reviews'];
  if (reviews is List) return reviews;
  if (reviews is Map) {
    final reviewMap = Map<String, dynamic>.from(reviews);
    final data = reviewMap['data'] ?? reviewMap['items'] ?? reviewMap['docs'];
    if (data is List) return data;
  }

  final profile = json['profile'];
  if (profile is Map) {
    final profileMap = Map<String, dynamic>.from(profile);
    final profileReviews = profileMap['reviews'];
    if (profileReviews is List) return profileReviews;
  }

  return const [];
}

int _intFromAny(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class TypicalRate {
  final int amount;
  final String unit;

  TypicalRate({required this.amount, required this.unit});

  factory TypicalRate.fromJson(Map<String, dynamic> json) {
    return TypicalRate(
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      unit: json['unit']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'unit': unit};
  }
}

class ContactChangeRequest {
  final String requestedName;
  final String requestedPhoneNumber;
  final String reason;
  final String status;
  final dynamic requestedAt;

  ContactChangeRequest({
    required this.requestedName,
    required this.requestedPhoneNumber,
    required this.reason,
    required this.status,
    this.requestedAt,
  });

  factory ContactChangeRequest.fromJson(Map<String, dynamic> json) {
    return ContactChangeRequest(
      requestedName: json['requestedName']?.toString() ?? '',
      requestedPhoneNumber: json['requestedPhoneNumber']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      requestedAt: json['requestedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestedName': requestedName,
      'requestedPhoneNumber': requestedPhoneNumber,
      'reason': reason,
      'status': status,
      'requestedAt': requestedAt,
    };
  }
}

List<String> _extraSkillsFromJson(Map<String, dynamic> json) {
  final extraSkills = _stringListFromAny(
    _firstNonNull([
      json['extraSkills'],
      json['extraSkill'],
      json['extraTrades'],
      json['extraTrade'],
      json['extra_skills'],
      json['extra_trades'],
    ]),
  );
  if (extraSkills.isNotEmpty) return extraSkills;

  final skills = _stringListFromAny(json['skills']);
  final mainSkill = json['mainSkill']?.toString().trim().toLowerCase() ?? '';
  return skills
      .where((skill) => skill.trim().isNotEmpty)
      .where((skill) => skill.trim().toLowerCase() != mainSkill)
      .toList();
}

dynamic _firstNonNull(List<dynamic> values) {
  for (final value in values) {
    if (value != null) return value;
  }
  return null;
}

List<String> _stringListFromAny(dynamic value) {
  if (value is List) {
    return value
        .map((skill) => skill?.toString().trim() ?? '')
        .where((skill) => skill.isNotEmpty)
        .toList();
  }

  final skill = value?.toString().trim() ?? '';
  return skill.isEmpty ? const [] : [skill];
}

class User {
  final ProfileImage profileImage;
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String area;
  final String name;
  final String userId;

  User({
    required this.profileImage,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.area,
    required this.name,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      profileImage: ProfileImage.fromJson(
        json['profileImage'] is Map
            ? Map<String, dynamic>.from(json['profileImage'])
            : {},
      ),
      id: json['_id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      userId: json['id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileImage': profileImage.toJson(),
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'area': area,
      'name': name,
      'id': userId,
    };
  }
}

class ProfileImage {
  final String publicId;
  final String url;

  ProfileImage({required this.publicId, required this.url});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      publicId: json['public_id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'url': url};
  }
}

class Review {
  final String id;
  final String reviewerName;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'] ?? json['user'] ?? json['client'];
    final reviewerMap = reviewer is Map
        ? Map<String, dynamic>.from(reviewer)
        : null;
    final firstName = reviewerMap?['firstName']?.toString().trim() ?? '';
    final lastName = reviewerMap?['lastName']?.toString().trim() ?? '';
    final name = reviewerMap?['name']?.toString().trim();
    final reviewerName = name != null && name.isNotEmpty
        ? name
        : [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

    return Review(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      reviewerName: reviewerName.isNotEmpty
          ? reviewerName
          : json['reviewerName']?.toString() ?? 'Anonymous',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment:
          json['comment']?.toString() ??
          json['reviewText']?.toString() ??
          json['review']?.toString() ??
          json['text']?.toString() ??
          '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reviewerName': reviewerName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}
