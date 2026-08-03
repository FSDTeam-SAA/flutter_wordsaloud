class SignInRequestModel {
  final String email;
  final String otp;
  final String? role;

  SignInRequestModel({required this.email, required this.otp, this.role});

  Map<String, dynamic> toJson() {
    final json = {'email': email, 'otp': otp};
    final trimmedRole = role?.trim();
    if (trimmedRole != null && trimmedRole.isNotEmpty) {
      json['role'] = trimmedRole;
    }
    return json;
  }
}
