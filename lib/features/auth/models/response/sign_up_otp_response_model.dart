class SignUpOtpResponseModel {
  final OtpData? data;

  SignUpOtpResponseModel({
    this.data,
  });

  factory SignUpOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpOtpResponseModel(
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