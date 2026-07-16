class SignUpOtpRequestModel {
  final String email;

  SignUpOtpRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}