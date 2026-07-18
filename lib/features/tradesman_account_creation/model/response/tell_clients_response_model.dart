class TellClientsResponseModel {
  final TradesmanProfileData? data;

  TellClientsResponseModel({this.data});

  factory TellClientsResponseModel.fromJson(Map<String, dynamic> json) {
    return TellClientsResponseModel(
      data: json['data'] != null
          ? TradesmanProfileData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class TradesmanProfileData {
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
  final List<dynamic>? workPhotos;
  final String? mainSkill;
  final String? homeArea;
  final String? travelRange;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  TradesmanProfileData({
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

  factory TradesmanProfileData.fromJson(Map<String, dynamic> json) {
    return TradesmanProfileData(
      id: json['_id'],
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
      workPhotos: json['workPhotos'] != null
          ? List<dynamic>.from(json['workPhotos'])
          : [],
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
      'workPhotos': workPhotos,
      'mainSkill': mainSkill,
      'homeArea': homeArea,
      'travelRange': travelRange,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class TypicalRate {
  final num? amount;
  final String? unit;

  TypicalRate({this.amount, this.unit});

  factory TypicalRate.fromJson(Map<String, dynamic> json) {
    return TypicalRate(amount: json['amount'], unit: json['unit']);
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'unit': unit};
  }
}
