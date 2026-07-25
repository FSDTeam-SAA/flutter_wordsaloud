import 'dart:developer' as d_print;

import 'package:flutter_wordsaloud/features/auth/models/request/sign_in_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/request/sign_up_otp_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/models/request/verify_mail_request_model.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_in_screen.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../home/screens/home_screen.dart';
import '../../tradesman_account_creation/screens/tradesman_dashboard.dart';
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

  Future resendOTP(String email) async {
    final request = SignUpOtpRequestModel(email: email);
    final result = await _authRepo.resendOtp(request);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("resend otp result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        d_print.log("resend otp result : ${success.data}");
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
          final isProfileCompleted = await _authStorageService
              .isTradesmanProfileCompleted(userId: user.id);

          Get.offAll(
            () => isProfileCompleted
                ? const TradesmanDashboard(tradesmanName: 'Tradesman')
                : const WhatDoScreen(),
          );
        } else {
          Get.offAll(() => const HomeScreen());
        }
        setLoading(false);
      },
    );
  }
}
