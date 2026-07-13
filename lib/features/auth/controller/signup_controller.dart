import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_wordsaloud/features/auth/controller/role_selection_controller.dart';
import 'package:flutter_wordsaloud/features/home/screens/home_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/what_do_screen.dart';

class SignupController extends GetxController {
  final RxBool isSmsCodeVisible = false.obs;
  final RxString phoneNumber = "".obs;
  final RxString email = "".obs;
  final RxString smsCode = "".obs;
  final RxString firstName = "".obs;
  final RxString lastName = "".obs;
  final RxString area = "".obs;
  final RxString emailError = "".obs;
  final RxString firstNameError = "".obs;
  final RxString lastNameError = "".obs;
  final RxString smsCodeError = "".obs;

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

      // First press: Trigger SMS/Email code sending
      sendVerificationCode();
      isSmsCodeVisible.value = true;
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

  void sendVerificationCode() {
    // Logic to send code to email
    print("Verification code sent to ${email.value}");
  }

  void completeSignup() {
    // Logic to finish signup
    print("Signup completed for ${firstName.value}");
    
    final roleSelectionController = Get.isRegistered<RoleSelectionController>()
        ? Get.find<RoleSelectionController>()
        : null;
    final isTradesman = roleSelectionController?.selectedRole.value == 1;
    
    if (isTradesman) {
      Get.to(() => const WhatDoScreen());
    } else {
      // Role 0: I need a tradesman → go to HomeScreen
      Get.offAll(() => const HomeScreen());
    }
  }
}
