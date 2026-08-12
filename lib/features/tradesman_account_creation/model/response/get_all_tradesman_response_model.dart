class GetAllTradesmanResponseModel {
  final List<Tradesman> data;
  final Meta meta;

  GetAllTradesmanResponseModel({required this.data, required this.meta});

  factory GetAllTradesmanResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] ?? json['tradesmen'] ?? json['items'] ?? [];
    return GetAllTradesmanResponseModel(
      data: tradesmanListFromJson(rawData),
      meta: Meta.fromJson(
        json['meta'] is Map ? Map<String, dynamic>.from(json['meta']) : {},
      ),
    );
  }

  factory GetAllTradesmanResponseModel.fromData(dynamic data) {
    return GetAllTradesmanResponseModel(
      data: tradesmanListFromJson(data),
      meta: Meta.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

List<Tradesman> tradesmanListFromJson(dynamic json) {
  if (json is Map) {
    final map = Map<String, dynamic>.from(json);
    return tradesmanListFromJson(
      map['data'] ??
          map['tradesmen'] ??
          map['items'] ??
          map['results'] ??
          map['docs'] ??
          const [],
    );
  }

  if (json is! List) return const [];

  return json
      .whereType<Map>()
      .map((item) => Tradesman.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

class Tradesman {
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
  final String homeArea;
  final String travelRange;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tradesman({
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
    required this.homeArea,
    required this.travelRange,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tradesman.fromJson(Map<String, dynamic> json) {
    final profileJson = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'])
        : json['tradesman'] is Map
        ? Map<String, dynamic>.from(json['tradesman'])
        : json;

    return Tradesman(
      typicalRate: TypicalRate.fromJson(
        profileJson['typicalRate'] is Map
            ? Map<String, dynamic>.from(profileJson['typicalRate'])
            : {},
      ),
      contactChangeRequest: ContactChangeRequest.fromJson(
        profileJson['contactChangeRequest'] is Map
            ? Map<String, dynamic>.from(profileJson['contactChangeRequest'])
            : {},
      ),
      id: profileJson['_id']?.toString() ?? json['_id']?.toString() ?? '',
      user: User.fromJson(
        profileJson['user'] is Map
            ? Map<String, dynamic>.from(profileJson['user'])
            : json['user'] is Map
            ? Map<String, dynamic>.from(json['user'])
            : {},
      ),
      extraSkills: _extraSkillsFromJson(profileJson),
      pitch: profileJson['pitch']?.toString() ?? '',
      verificationStatus: profileJson['verificationStatus']?.toString() ?? '',
      isLive: _boolFromAny(
        Tradesman._firstNonNull([profileJson['isLive'], json['isLive']]),
      ),
      isVip: _boolFromAny(
        Tradesman._firstNonNull([
          profileJson['isVip'],
          profileJson['isVIP'],
          profileJson['vip'],
          profileJson['isFeatured'],
          profileJson['featured'],
          json['isVip'],
          json['isVIP'],
          json['vip'],
          json['isFeatured'],
          json['featured'],
        ]),
      ),
      ratingAverage: _ratingAverageFromJson(json, profileJson),
      ratingCount: _ratingCountFromJson(json, profileJson),
      jobsCount: (profileJson['jobsCount'] as num?)?.toInt() ?? 0,
      workPhotos: List<dynamic>.from(profileJson['workPhotos'] ?? const []),
      mainSkill: profileJson['mainSkill']?.toString() ?? '',
      homeArea: profileJson['homeArea']?.toString() ?? '',
      travelRange: profileJson['travelRange']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(profileJson['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(profileJson['updatedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Tradesman copyWith({
    TypicalRate? typicalRate,
    ContactChangeRequest? contactChangeRequest,
    String? id,
    User? user,
    List<String>? extraSkills,
    String? pitch,
    String? verificationStatus,
    bool? isLive,
    bool? isVip,
    num? ratingAverage,
    int? ratingCount,
    int? jobsCount,
    List<dynamic>? workPhotos,
    String? mainSkill,
    String? homeArea,
    String? travelRange,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tradesman(
      typicalRate: typicalRate ?? this.typicalRate,
      contactChangeRequest: contactChangeRequest ?? this.contactChangeRequest,
      id: id ?? this.id,
      user: user ?? this.user,
      extraSkills: extraSkills ?? this.extraSkills,
      pitch: pitch ?? this.pitch,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isLive: isLive ?? this.isLive,
      isVip: isVip ?? this.isVip,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
      jobsCount: jobsCount ?? this.jobsCount,
      workPhotos: workPhotos ?? this.workPhotos,
      mainSkill: mainSkill ?? this.mainSkill,
      homeArea: homeArea ?? this.homeArea,
      travelRange: travelRange ?? this.travelRange,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static num _ratingAverageFromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> profileJson,
  ) {
    return _numFromAny(
      _firstNonNull([
        profileJson['ratingAverage'],
        profileJson['averageRating'],
        profileJson['avgRating'],
        profileJson['ratingAvg'],
        json['ratingAverage'],
        json['averageRating'],
        json['avgRating'],
        json['ratingAvg'],
        _nestedValue(profileJson, ['rating', 'average']),
        _nestedValue(profileJson, ['ratings', 'average']),
        _nestedValue(profileJson, ['reviews', 'average']),
        _nestedValue(json, ['rating', 'average']),
        _nestedValue(json, ['ratings', 'average']),
        _nestedValue(json, ['reviews', 'average']),
        profileJson['rating'] is num || profileJson['rating'] is String
            ? profileJson['rating']
            : null,
        json['rating'] is num || json['rating'] is String
            ? json['rating']
            : null,
      ]),
    );
  }

  static int _ratingCountFromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> profileJson,
  ) {
    final count = _intFromAny(
      _firstNonNull([
        profileJson['ratingCount'],
        profileJson['reviewCount'],
        profileJson['reviewsCount'],
        profileJson['totalReviews'],
        profileJson['reviewsTotal'],
        json['ratingCount'],
        json['reviewCount'],
        json['reviewsCount'],
        json['totalReviews'],
        json['reviewsTotal'],
        _nestedValue(profileJson, ['rating', 'count']),
        _nestedValue(profileJson, ['ratings', 'count']),
        _nestedValue(profileJson, ['reviews', 'count']),
        _nestedValue(json, ['rating', 'count']),
        _nestedValue(json, ['ratings', 'count']),
        _nestedValue(json, ['reviews', 'count']),
        _nestedValue(profileJson, ['_count', 'reviews']),
        _nestedValue(json, ['_count', 'reviews']),
      ]),
    );

    if (count > 0) return count;

    final reviews =
        profileJson['reviews'] ??
        json['reviews'] ??
        _nestedValue(profileJson, ['reviews', 'data']) ??
        _nestedValue(json, ['reviews', 'data']);
    if (reviews is List) return reviews.length;

    return 0;
  }

  static dynamic _firstNonNull(List<dynamic> values) {
    for (final value in values) {
      if (value != null) return value;
    }
    return null;
  }

  static dynamic _nestedValue(Map<String, dynamic> json, List<String> keys) {
    dynamic current = json;
    for (final key in keys) {
      if (current is! Map) return null;
      current = current[key];
    }
    return current;
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
      'homeArea': homeArea,
      'travelRange': travelRange,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

num _numFromAny(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

int _intFromAny(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _boolFromAny(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
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
    required this.requestedAt,
  });

  factory ContactChangeRequest.fromJson(Map<String, dynamic> json) {
    return ContactChangeRequest(
      requestedName: json['requestedName'] ?? '',
      requestedPhoneNumber: json['requestedPhoneNumber'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
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
    Tradesman._firstNonNull([
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
  final String area;
  final String name;
  final String userId;

  User({
    required this.profileImage,
    required this.id,
    required this.firstName,
    required this.lastName,
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
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'url': url};
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  factory Meta.empty() {
    return Meta(total: 0, page: 1, limit: 20, totalPages: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
