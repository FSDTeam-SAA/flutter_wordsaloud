import 'dart:developer' as DPrint;

import 'package:flutter_wordsaloud/features/auth/controller/auth_controller.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_in_screen.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final RxBool isSmsCodeVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxString email = "".obs;
  final RxString smsCode = "".obs;
  final RxString firstName = "".obs;
  final RxString lastName = "".obs;
  final RxString area = "".obs;
  final RxString emailError = "".obs;
  final RxString firstNameError = "".obs;
  final RxString lastNameError = "".obs;
  final RxString smsCodeError = "".obs;
  final RxString apiError = "".obs;

  void onMainButtonPressed() {
    if (!isSmsCodeVisible.value) {
      // Validation Check: Empty email fields
      if (email.value.trim().isEmpty) {
        emailError.value = "You did not give your email address.";
        return;
      }

      emailError.value = "";

      // Validation Check: Correct email format
      if (!GetUtils.isEmail(email.value.trim())) {
        emailError.value = "Please enter a correct email address.";
        return;
      }

      emailError.value = "";
      apiError.value = "";

      // First press: Trigger email OTP sending
      sendVerificationCode();
    } else {
      // Second press: Validate SMS code, names and complete signup
      if (smsCode.value.trim().isEmpty) {
        smsCodeError.value = "Verification code is required.";
        return;
      }
      smsCodeError.value = "";

      if (firstName.value.trim().isEmpty) {
        firstNameError.value = "First name is required.";
        return;
      }
      firstNameError.value = "";

      if (lastName.value.trim().isEmpty) {
        lastNameError.value = "Last name is required.";
        return;
      }
      lastNameError.value = "";

      // Area is optional, no validation needed
      completeSignup();
    }
  }

  Future<void> sendVerificationCode() async {
    isLoading.value = true;
    apiError.value = "";

    try {
      final authCtrl = Get.find<AuthController>();
      await authCtrl.verifyOTPRegister(email.value.trim());

      // Check if AuthController reported an error
      if (authCtrl.errorMessage.value.isNotEmpty) {
        apiError.value = authCtrl.errorMessage.value;
        authCtrl.clearError();
      } else {
        // Success: show verification code field
        isSmsCodeVisible.value = true;
        DPrint.log("OTP sent successfully to ${email.value}");
      }
    } catch (e) {
      apiError.value = "Something went wrong. Please try again.";
      DPrint.log("sendVerificationCode error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void completeSignup() {
    // Logic to finish signup
    Get.offAll(() => const SignInScreen());
  }
}
