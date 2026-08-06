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
  static const accountNotFoundMessage =
      'No account found with this email. Please sign up first.';

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

  Future verifyEmailRegister(String email, {String? role}) async {
    final loginRole = role?.trim();
    final request = VerifyMailRequestModel(email: email, role: loginRole);
    final result = await _authRepo.emailVerify(request);

    result.fold(
      (fail) {
        setError(_loginErrorMessage(fail.message, fail.statusCode));
        d_print.log("verify otp success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        final accountRole = _normalizeRole(success.data.data?.role);
        final selectedLoginRole = _normalizeRole(loginRole);

        if (selectedLoginRole.isNotEmpty &&
            accountRole.isNotEmpty &&
            accountRole != selectedLoginRole) {
          setError(_roleMismatchMessage(selectedLoginRole));
          setLoading(false);
          return;
        }

        d_print.log(
          "verify otp success result : ${success.data} selectedRole=$selectedLoginRole accountRole=${accountRole.isEmpty ? 'not returned' : accountRole}",
        );
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
    String phoneNumber,
  ) async {
    if (role.trim().isEmpty) {
      setError('Please select whether you are a client or tradesman first.');
      setLoading(false);
      return;
    }

    final request = RegisterRequestModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      otp: otp,
      role: role,
      area: area,
      phoneNumber: phoneNumber,
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
  }) async {
    final request = SignInRequestModel(email: email, otp: verificationCode);

    final result = await _authRepo.login(request);

    d_print.log("Login Response ${result.isRight()}");

    await result.fold<Future<void>>(
      (fail) async {
        setError(_loginErrorMessage(fail.message, fail.statusCode));
        setLoading(false);
      },
      (success) async {
        // Extract user data
        final user = success.data;
        final accountRole = _normalizeRole(user.role);
        final role = accountRole;
        if (role.isEmpty) {
          setError(
            'We could not find this account role. Please contact support.',
          );
          setLoading(false);
          return;
        }
        currentUserName.value = _displayName(
          name: user.name,
          firstName: user.firstName,
          lastName: user.lastName,
        );

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
                ? TradesmanDashboard(
                    tradesmanName: currentUserName.value.trim().isNotEmpty
                        ? currentUserName.value.trim()
                        : 'Tradesman',
                  )
                : const WhatDoScreen(),
          );
        } else {
          Get.offAll(() => const HomeScreen());
        }
        setLoading(false);
      },
    );
  }

  String _normalizeRole(String? role) {
    final value = role?.trim().toLowerCase() ?? '';
    if (value == 'user') return 'client';
    return value;
  }

  String _displayName({String? name, String? firstName, String? lastName}) {
    final explicitName = name?.trim() ?? '';
    if (explicitName.isNotEmpty) return explicitName;

    return [
      firstName?.trim() ?? '',
      lastName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }

  String _loginErrorMessage(String message, int statusCode) {
    final normalizedMessage = message.toLowerCase();
    final isMissingAccount =
        statusCode == 404 ||
        normalizedMessage.contains('no account') ||
        normalizedMessage.contains('account not found') ||
        normalizedMessage.contains('user not found') ||
        normalizedMessage.contains('email not found') ||
        normalizedMessage.contains('not exist') ||
        normalizedMessage.contains('not registered') ||
        normalizedMessage == 'resource not found';

    if (isMissingAccount) return accountNotFoundMessage;
    if (normalizedMessage.contains('password')) {
      return 'Please enter the verification code sent to your email.';
    }
    return message;
  }

  String _roleMismatchMessage(String selectedRole) {
    if (selectedRole == 'client') {
      return 'This is not a client account.';
    }
    if (selectedRole == 'tradesman') {
      return 'This is not a tradesman account.';
    }
    return 'This account does not match the selected role.';
  }
}
