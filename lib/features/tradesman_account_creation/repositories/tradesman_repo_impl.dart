import 'package:dio/dio.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tell_clients_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/repositories/tradesman_repo.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/network_result.dart';
import '../../../core/network/constants/api_constants.dart';
import '../model/request/tradesman_area_request_model.dart';
import '../model/request/tradesman_skill_request_model.dart';
import '../model/response/tradesman_area_response_model.dart';
import '../model/response/tradesman_skill_response_model.dart';

class TradesmanRepositoryImpl implements TradesmanRepo {
  final ApiClient _apiClient;

  TradesmanRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<TradesmanSkillResponseModel> whatCanDo(
    TradesmanSkillRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.whatCan,
      data: request.toJson(),
      fromJsonT: (json) => TradesmanSkillResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<TradesmanAreaResponseModel> tradesmanArea(
    TradesmanAreaRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.whereWork,
      data: request.toJson(),
      fromJsonT: (json) => TradesmanAreaResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<TellClientsResponseModel> tellClient(FormData formData) {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.tellClient,
      formData: formData,
      fromJsonT: (json) => TellClientsResponseModel.fromJson(json),
    );
  }
  // @override
  // NetworkResult<VerifyEmailResponseModel> emailVerify(
  //     VerifyMailRequestModel request,
  //     ) {
  //   return _apiClient.post(
  //     endpoint: ApiConstants.auth.verifyEmail,
  //     data: request.toJson(),
  //     fromJsonT: (json) => VerifyEmailResponseModel.fromJson(json),
  //   );
  // }
  //
  // @override
  // NetworkResult<RegisterResponseModel> register(RegisterRequestModel request) {
  //   return _apiClient.post(
  //     endpoint: ApiConstants.auth.register,
  //     data: request.toJson(),
  //     fromJsonT: (json) => RegisterResponseModel.fromJson(json),
  //   );
  // }
  //
  // @override
  // NetworkResult<LoginResponseModel> login(SignInRequestModel request) {
  //   return _apiClient.post(
  //     endpoint: ApiConstants.auth.login,
  //     data: request.toJson(),
  //     fromJsonT: (json) => LoginResponseModel.fromJson(json),
  //   );
  // }

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
