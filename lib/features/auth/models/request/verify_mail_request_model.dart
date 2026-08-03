class VerifyMailRequestModel {
  final String email;
  final String? role;

  VerifyMailRequestModel({required this.email, this.role});

  Map<String, dynamic> toJson() {
    final json = {'email': email};
    final trimmedRole = role?.trim();
    if (trimmedRole != null && trimmedRole.isNotEmpty) {
      json['role'] = trimmedRole;
    }
    return json;
  }
}
