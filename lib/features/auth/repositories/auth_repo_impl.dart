import 'package:flutter_wordsaloud/features/auth/models/request/sign_up_otp_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/response/sign_up_otp_response_model.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/network_result.dart';
import '../../../core/network/constants/api_constants.dart';
import '../models/request/register_request_model.dart';
import '../models/request/sign_in_request_model.dart';
import '../models/request/verify_mail_request_model.dart';
import '../models/response/login_response_model.dart';
import '../models/response/register_response_model.dart';
import '../models/response/verify_email_response_model.dart';
import 'auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<SignUpOtpResponseModel> otpVerify(
    SignUpOtpRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.verifyOtp,
      data: request.toJson(),
      fromJsonT: (json) => SignUpOtpResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<SignUpOtpResponseModel> resendOtp(
    SignUpOtpRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.resendOtp,
      data: request.toJson(),
      fromJsonT: (json) => SignUpOtpResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<VerifyEmailResponseModel> emailVerify(
    VerifyMailRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.verifyEmail,
      data: request.toJson(),
      fromJsonT: (json) => VerifyEmailResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.register,
      data: request.toJson(),
      fromJsonT: (json) => RegisterResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<LoginResponseModel> login(SignInRequestModel request) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.login,
      data: request.toJson(),
      fromJsonT: (json) => LoginResponseModel.fromJson(json),
    );
  }

  //
  // @override
  // NetworkResult<ForgotPasswordResponseModel> forgotPassword(
  //     ForgotPasswordRequestModel request) {
  //   return _apiClient.post(endpoint: ApiConstants.auth.forgotPassword,
  //       data: request.toJson(),
  //       fromJsonT: (json) => ForgotPasswordResponseModel.fromJson(json));
  // }
  //
  // @override
  // NetworkResult<void> verifyOtp(VerifyOtpRequestModel request) {
  //   return _apiClient.post(endpoint: ApiConstants.auth.verifyOtp,
  //       data: request.toJson(),
  //       fromJsonT: (json) {});
  // }
  //
  // @override
  // NetworkResult<void> createNewPassword(CreateNewPasswordRequestModel request) {
  //   return _apiClient.post(
  //       endpoint: ApiConstants.auth.resetPassword,
  //       data: request.toJson(),
  //       fromJsonT: (json) {});
  // }
  //
  // @override
  // NetworkResult<LoginResponseModel> refreshToken(
  //     RefreshTokenRequestModel request,) {
  //   return _apiClient.post(
  //     endpoint: ApiConstants.auth.refreshToken,
  //     data: request.toJson(),
  //     fromJsonT: (json) => LoginResponseModel.fromJson(json),
  //   );
  // }
  //
  // @override
  // NetworkResult<RefreshTokenResponseModel> refreshTOken(
  //     RefreshTokenRequestModel request,) {
  //   return _apiClient.post(
  //     endpoint: ApiConstants.auth.refreshToken,
  //     data: request.toJson(),
  //     fromJsonT: (json) => RefreshTokenResponseModel.fromJson(json),
  //   );
  // }
}
