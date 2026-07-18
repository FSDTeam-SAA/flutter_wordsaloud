class LoginResponseModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? area;
  final bool? isEmailVerified;
  final String? accessToken;
  final String? refreshToken;

  LoginResponseModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.role,
    this.area,
    this.isEmailVerified,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      area: json['area'],
      isEmailVerified: json['isEmailVerified'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'area': area,
      'isEmailVerified': isEmailVerified,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}