class VerifyEmailResponseModel {
  final OtpData? data;

  VerifyEmailResponseModel({
    this.data,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      data: json['data'] != null
          ? OtpData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class OtpData {
  final String? email;
  final String? otp;

  OtpData({
    this.email,
    this.otp,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      email: json['email'],
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}