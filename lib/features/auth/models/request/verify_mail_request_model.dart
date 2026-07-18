class VerifyMailRequestModel {
  final String email;

  VerifyMailRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}