class TradesmanSkillRequestModel {
  final String mainSkill;
  final List<String> extraSkills;

  TradesmanSkillRequestModel({
    required this.mainSkill,
    required this.extraSkills,
  });

  Map<String, dynamic> toJson() {
    final skills = [
      mainSkill,
      ...extraSkills,
    ].where((skill) => skill.trim().isNotEmpty).toList();

    return {
      'mainSkill': mainSkill,
      'extraSkills': extraSkills,
      'skills': skills,
    };
  }
}
