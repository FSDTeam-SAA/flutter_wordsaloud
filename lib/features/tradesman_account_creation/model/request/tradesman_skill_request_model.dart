class TradesmanSkillRequestModel {
  final String mainSkill;
  final List<String> extraSkills;

  TradesmanSkillRequestModel({
    required this.mainSkill,
    required this.extraSkills,
  });

  Map<String, dynamic> toJson() {
    return {
      'mainSkill': mainSkill,
      'extraSkills': extraSkills,
    };
  }
}