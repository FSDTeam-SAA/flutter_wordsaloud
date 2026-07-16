
import 'package:flutter_wordsaloud/features/auth/models/request/register_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/request/sign_up_otp_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/response/register_response_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/response/sign_up_otp_response_model.dart';

import '../../../core/network/network_result.dart';

abstract class AuthRepository {

  //Auth
  NetworkResult<SignUpOtpResponseModel> otpVerify(SignUpOtpRequestModel request);
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request);
  // NetworkResult<LoginResponseModel> login(LoginRequestModel request);
  // NetworkResult<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request);
  // NetworkResult<void> verifyOtp(VerifyOtpRequestModel request);
  // NetworkResult<void> createNewPassword(CreateNewPasswordRequestModel request);
  // NetworkResult<RefreshTokenResponseModel> refreshTOken(RefreshTokenRequestModel request);
  //
  // NetworkResult<LoginResponseModel> refreshToken(RefreshTokenRequestModel request);
}
