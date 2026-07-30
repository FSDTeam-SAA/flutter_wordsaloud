class VerifyEmailResponseModel {
  final OtpData? data;

  VerifyEmailResponseModel({this.data});

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      data: json['data'] != null ? OtpData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class OtpData {
  final String? email;
  final String? otp;
  final String? role;

  OtpData({this.email, this.otp, this.role});

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(email: json['email'], otp: json['otp'], role: json['role']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp, 'role': role};
  }
}
