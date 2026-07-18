import 'dart:developer' as d_print;

import 'package:flutter_wordsaloud/features/auth/models/request/sign_in_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/request/sign_up_otp_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/request/verify_mail_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_in_screen.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../home/screens/home_screen.dart';
import '../../tradesman_account_creation/screens/what_do_screen.dart';
import '../models/request/register_request_model.dart';
import '../repositories/auth_repo.dart';

class AuthController extends BaseController {
  late final _authRepo = Get.find<AuthRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final currentUserName = ''.obs;

  //
  // AuthController(this._authRepo, this._authStorageService);

  Future verifyOTPRegister(String email) async {
    final request = SignUpOtpRequestModel(email: email);
    final result = await _authRepo.otpVerify(request);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("verify otp success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        d_print.log("verify otp success result : ${success.data}");
        setLoading(false);
      },
    );
  }

  Future verifyEmailRegister(String email) async {
    final request = VerifyMailRequestModel(email: email);
    final result = await _authRepo.emailVerify(request);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("verify otp success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        d_print.log("verify otp success result : ${success.data}");
        setLoading(false);
      },
    );
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String otp,
    String role,
    String area,
  ) async {
    final request = RegisterRequestModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      otp: otp,
      role: role,
      area: area,
    );

    final result = await _authRepo.register(request);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Register success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        d_print.log("Register success result : ${success.data}");
        Get.to(SignInScreen());
        setLoading(false);
      },
    );
  }

  //
  //
  //
  // // Login
  //
  Future<void> login({
    required String email,
    required String verificationCode,
    String? selectedRole,
  }) async {
    final request = SignInRequestModel(email: email, otp: verificationCode);

    final result = await _authRepo.login(request);

    d_print.log("Login Response ${result.isRight()}");

    await result.fold<Future<void>>(
      (fail) async {
        setError(fail.message);
        setLoading(false);
      },
      (success) async {
        // Extract user data
        final user = success.data;
        final role = user.role ?? selectedRole ?? 'client';
        currentUserName.value = user.name?.trim() ?? '';

        // Store access token and refresh token for ANY user
        await _authStorageService.storeAuthData(
          accessToken: success.data.accessToken,
          refreshToken: success.data.refreshToken,
          userId: user.id,
          role: role,
        );

        if (role.toLowerCase() == "tradesman") {
          Get.offAll(() => const WhatDoScreen());
        } else {
          Get.offAll(() => const HomeScreen());
        }
        setLoading(false);
      },
    );
  }

  //
  // //
  // Future forgotPass(String email) async {
  //   final request = ForgotPasswordRequestModel(email: email);
  //   final result = await _authRepo.forgotPassword(request);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       setLoading(false);
  //     },
  //         (success) {
  //       Get.off(() => VerifyCodeScreen(email: email)); //changed
  //       setLoading(false);
  //     },
  //   );
  // }
  //
  // Future verifyOTP(String email, String otp) async {
  //   final request = VerifyOtpRequestModel(email: email, otp: otp);
  //   final result = await _authRepo.verifyOtp(request);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       d_print.log("verify otp success result : ${fail.message}");
  //     },
  //         (success) {
  //       d_print.log("verify otp success result : ${success.message}");
  //       Get.to(CreateNewPasswordScreen(email: email, otp: otp));
  //     },
  //   );
  // }
  //
  // Future createNewPass(String email, String otp, String newPassword) async {
  //   final request = CreateNewPasswordRequestModel(
  //     email: email,
  //     otp: otp,
  //     newPassword: newPassword,
  //   );
  //   final result = await _authRepo.createNewPassword(request);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       d_print.log("New Password set failed result : ${fail.message}");
  //     },
  //         (success) {
  //       d_print.log("New Password set successfully result : ${success.message}");
  //       Get.offAll(LoginScreen());
  //     },
  //   );
  // }
  //
  // //
  // Future refreshToken() async {
  //   setLoading(true);
  //
  //   final refreshToken = await _authStorageService.getRefreshToken();
  //   d_print.log("Got refresh token: $refreshToken");
  //   final request = RefreshTokenRequestModel(refreshToken: refreshToken);
  //
  //   final result = await _authRepo.refreshToken(request);
  //
  //   final navi = result.fold(
  //         (fail) {
  //       d_print.log("Refresh token failed: ${fail.message}");
  //       return _isSuccess = false;
  //     },
  //         (success) async {
  //       d_print.log("Refresh token success: ${success.message}");
  //       await _authStorageService.storeAccessToken(
  //         accessToken: success.data.accessToken,
  //       );
  //       await _authStorageService.storeRefreshToken(
  //         refreshToken: success.data.refreshToken,
  //       );
  //       //await _authStorageService.storeRefreshToken(success.data.refreshToken);
  //       return _isSuccess = true;
  //     },
  //   );
  //   return navi;
  // }
  //
  // final SecureStoreServices _secureStoreServices = SecureStoreServices();
  // //
  // Future<void> logout() async {
  //   if (Get.isRegistered<OrderController>()) {
  //     Get.find<OrderController>().reset();
  //   }
  //
  //   await _authStorageService.clearAuthData();
  //   await _secureStoreServices.deleteData(KeyConstants.conversationId);
  //
  //   Get.offAll(() => FirstScreen());
  // }
}
