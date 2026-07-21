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
    final rawReviews = json['reviews'] is List ? json['reviews'] as List : [];

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
      extraSkills: List<String>.from(json['extraSkills'] ?? const []),
      pitch: json['pitch']?.toString() ?? '',
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      isLive: json['isLive'] == true,
      isVip: json['isVip'] == true,
      ratingAverage: json['ratingAverage'] is num ? json['ratingAverage'] : 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
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
  Review();

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
