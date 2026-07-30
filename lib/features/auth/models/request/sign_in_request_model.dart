class SignInRequestModel {
  final String email;
  final String otp;
  final String role;

  SignInRequestModel({
    required this.email,
    required this.otp,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp, 'role': role};
  }
}
