import 'package:dio/dio.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_area_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tell_clients_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tradesman_area_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tradesman_skill_response_model.dart';

import '../../../core/network/network_result.dart';
import '../model/request/tradesman_skill_request_model.dart';

abstract class TradesmanRepo {
  NetworkResult<TradesmanSkillResponseModel> whatCanDo(
    TradesmanSkillRequestModel request,
  );
  NetworkResult<TradesmanAreaResponseModel> tradesmanArea(
    TradesmanAreaRequestModel request,
  );
  NetworkResult<TellClientsResponseModel> tellClient(FormData formData);
  // NetworkResult<RegisterResponseModel> register(RegisterRequestModel request);
  // NetworkResult<LoginResponseModel> login(SignInRequestModel request);
  // NetworkResult<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request);
  // NetworkResult<void> verifyOtp(VerifyOtpRequestModel request);
  // NetworkResult<void> createNewPassword(CreateNewPasswordRequestModel request);
  // NetworkResult<RefreshTokenResponseModel> refreshTOken(RefreshTokenRequestModel request);
  //
  // NetworkResult<LoginResponseModel> refreshToken(RefreshTokenRequestModel request);
}
