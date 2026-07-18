class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String otp;
  final String role;
  final String area;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.otp,
    required this.role,
    required this.area,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'otp': otp,
      'role': role,
      'area': area,
    };
  }
}