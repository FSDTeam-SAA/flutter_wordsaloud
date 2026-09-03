class SkillModel {
  final String? skill;
  final int? listedCount;
  final String? icon;
  final bool isNew;

  SkillModel({this.skill, this.listedCount, this.icon, this.isNew = false});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    final rawListedCount =
        json['listedCount'] ?? json['count'] ?? json['listed'];
    final rawIsNew = json['isNew'];

    return SkillModel(
      skill: (json['skill'] ?? json['name'] ?? json['category'])?.toString(),
      listedCount: rawListedCount is num
          ? rawListedCount.toInt()
          : int.tryParse((rawListedCount ?? '').toString()),
      icon: json['icon']?.toString(),
      isNew: rawIsNew is bool
          ? rawIsNew
          : rawIsNew?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'listedCount': listedCount,
      'icon': icon,
      'isNew': isNew,
    };
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
