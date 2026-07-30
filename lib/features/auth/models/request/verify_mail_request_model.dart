class VerifyMailRequestModel {
  final String email;
  final String role;

  VerifyMailRequestModel({required this.email, required this.role});

  Map<String, dynamic> toJson() {
    return {'email': email, 'role': role};
  }
}
