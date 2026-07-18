class TradesmanSkillResponseModel {
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
  final String? id;
  final List<dynamic>? workPhotos;
  final String? mainSkill;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  TradesmanSkillResponseModel({
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
    this.id,
    this.workPhotos,
    this.mainSkill,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TradesmanSkillResponseModel.fromJson(Map<String, dynamic> json) {
    return TradesmanSkillResponseModel(
      user: json['user'],
      extraSkills: json['extraSkills'] != null
          ? List<String>.from(json['extraSkills'])
          : [],
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
      id: json['_id'],
      workPhotos: json['workPhotos'] != null
          ? List<dynamic>.from(json['workPhotos'])
          : [],
      mainSkill: json['mainSkill'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      '_id': id,
      'workPhotos': workPhotos,
      'mainSkill': mainSkill,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
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