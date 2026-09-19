class SkillModel {
  final String? skill;
  final int? listedCount;
  final String? icon;
  final bool isNew;
  final bool isVip;

  SkillModel({
    this.skill,
    this.listedCount,
    this.icon,
    this.isNew = false,
    this.isVip = false,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    final listedCount = _intFromAny(
      json['tradesmanCount'] ??
          json['tradesmenCount'] ??
          json['listedCount'] ??
          json['count'] ??
          json['listed'],
    );
    final rawIsNew = json['isNew'];
    final rawIsVip = json['isVerified'] ?? json['isVip'] ?? json['isVIP'];

    return SkillModel(
      skill: (json['skill'] ?? json['name'] ?? json['category'])?.toString(),
      listedCount: listedCount,
      icon: json['icon']?.toString(),
      isNew: rawIsNew is bool
          ? rawIsNew
          : rawIsNew?.toString().toLowerCase() == 'true',
      isVip: rawIsVip is bool
          ? rawIsVip
          : rawIsVip?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'listedCount': listedCount,
      'icon': icon,
      'isNew': isNew,
      'isVip': isVip,
    };
  }

  static int? _intFromAny(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString());
  }
}

List<SkillModel> skillListFromJson(dynamic json) {
  final rawList = json is List
      ? json
      : json is Map
      ? json['categories'] ?? json['skills'] ?? json['items'] ?? json['data']
      : null;

  if (rawList is! List) return const [];

  return rawList
      .whereType<Map>()
      .map((item) => SkillModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
