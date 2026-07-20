class WorkPhoto {
  final String? id;
  final String? publicId;
  final String? url;

  WorkPhoto({
    this.id,
    this.publicId,
    this.url,
  });

  factory WorkPhoto.fromJson(Map<String, dynamic> json) {
    return WorkPhoto(
      id: json['_id'],
      publicId: json['public_id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'public_id': publicId,
      'url': url,
    };
  }
}

class TypicalRate {
  final num? amount;
  final String? unit;

  TypicalRate({
    this.amount,
    this.unit,
  });

  factory TypicalRate.fromJson(Map<String, dynamic> json) {
    return TypicalRate(
      amount: json['amount'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}

class GoLiveResponseModel {
  final String? id;
  final String? user;
  final List<String>? extraSkills;
  final String? pitch;
  final TypicalRate? typicalRate;
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

  GoLiveResponseModel({
    this.id,
    this.user,
    this.extraSkills,
    this.pitch,
    this.typicalRate,
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

  factory GoLiveResponseModel.fromJson(Map<String, dynamic> json) {
    return GoLiveResponseModel(
      id: json['_id'],
      user: json['user'],
      extraSkills: List<String>.from(json['extraSkills'] ?? []),
      pitch: json['pitch'],
      typicalRate: json['typicalRate'] != null
          ? TypicalRate.fromJson(json['typicalRate'])
          : null,
      verificationStatus: json['verificationStatus'],
      isLive: json['isLive'],
      isVip: json['isVip'],
      ratingAverage: json['ratingAverage'],
      ratingCount: json['ratingCount'],
      jobsCount: json['jobsCount'],
      workPhotos: (json['workPhotos'] as List<dynamic>?)
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'extraSkills': extraSkills,
      'pitch': pitch,
      'typicalRate': typicalRate?.toJson(),
      'verificationStatus': verificationStatus,
      'isLive': isLive,
      'isVip': isVip,
      'ratingAverage': ratingAverage,
      'ratingCount': ratingCount,
      'jobsCount': jobsCount,
      'workPhotos': workPhotos?.map((e) => e.toJson()).toList(),
      'mainSkill': mainSkill,
      'homeArea': homeArea,
      'travelRange': travelRange,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}