import 'dart:developer' as d_print;

import 'package:flutter_wordsaloud/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  final RxBool isCodeVisible = false.obs;
  final RxBool isSendingCode = false.obs;
  final RxBool isResendingCode = false.obs;
  final RxBool isLoggingIn = false.obs;
  final RxBool isAccountMissing = false.obs;
  final RxString email = ''.obs;
  final RxString code = ''.obs;
  final RxString emailError = ''.obs;
  final RxString codeError = ''.obs;
  final RxString apiError = ''.obs;

  Future<void> sendCode() async {
    if (email.value.trim().isEmpty) {
      emailError.value = 'Email address is required.';
      return;
    }

    if (!GetUtils.isEmail(email.value.trim())) {
      emailError.value = 'Please enter a correct email address.';
      return;
    }

    emailError.value = '';
    codeError.value = '';
    apiError.value = '';
    isAccountMissing.value = false;
    isSendingCode.value = true;

    try {
      final authCtrl = Get.find<AuthController>();
      authCtrl.clearError();

      await authCtrl.verifyEmailRegister(email.value.trim());

      if (authCtrl.errorMessage.value.isNotEmpty) {
        apiError.value = authCtrl.errorMessage.value;
        isAccountMissing.value =
            apiError.value == AuthController.accountNotFoundMessage;
        authCtrl.clearError();
      } else {
        isCodeVisible.value = true;
        d_print.log('OTP sent successfully to ${email.value}');
      }
    } catch (e) {
      apiError.value = 'Something went wrong. Please try again.';
      d_print.log('sendCode error: $e');
    } finally {
      isSendingCode.value = false;
    }
  }

  Future<void> resendCode() async {
    if (email.value.trim().isEmpty) {
      emailError.value = 'Email address is required.';
      return;
    }

    if (!GetUtils.isEmail(email.value.trim())) {
      emailError.value = 'Please enter a correct email address.';
      return;
    }

    emailError.value = '';
    codeError.value = '';
    apiError.value = '';
    isAccountMissing.value = false;
    isResendingCode.value = true;

    try {
      final authCtrl = Get.find<AuthController>();
      authCtrl.clearError();

      await authCtrl.resendOTP(email.value.trim());

      if (authCtrl.errorMessage.value.isNotEmpty) {
        apiError.value = authCtrl.errorMessage.value;
        isAccountMissing.value =
            apiError.value == AuthController.accountNotFoundMessage;
        authCtrl.clearError();
      } else {
        d_print.log('OTP resent successfully to ${email.value}');
      }
    } catch (e) {
      apiError.value = 'Something went wrong. Please try again.';
      d_print.log('resendCode error: $e');
    } finally {
      isResendingCode.value = false;
    }
  }

  Future<void> login() async {
    if (!isCodeVisible.value) {
      await sendCode();
      return;
    }

    if (email.value.trim().isEmpty) {
      emailError.value = 'Email address is required.';
      return;
    }

    if (!GetUtils.isEmail(email.value.trim())) {
      emailError.value = 'Please enter a correct email address.';
      return;
    }

    if (code.value.trim().length < 6) {
      codeError.value = 'Verification code is required.';
      return;
    }

    emailError.value = '';
    codeError.value = '';
    apiError.value = '';
    isAccountMissing.value = false;
    isLoggingIn.value = true;

    try {
      final authCtrl = Get.find<AuthController>();
      authCtrl.clearError();

      await authCtrl.login(
        email: email.value.trim(),
        verificationCode: code.value.trim(),
      );

      if (authCtrl.errorMessage.value.isNotEmpty) {
        apiError.value = authCtrl.errorMessage.value;
        isAccountMissing.value =
            apiError.value == AuthController.accountNotFoundMessage;
        authCtrl.clearError();
      }
    } catch (e) {
      apiError.value = 'Something went wrong. Please try again.';
      d_print.log('login error: $e');
    } finally {
      isLoggingIn.value = false;
    }
  }
}
