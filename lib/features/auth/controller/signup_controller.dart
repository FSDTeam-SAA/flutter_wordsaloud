import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final RxBool isSmsCodeVisible = false.obs;
  final RxString phoneNumber = "".obs;
  final RxString email = "".obs;
  final RxString smsCode = "".obs;
  final RxString firstName = "".obs;
  final RxString lastName = "".obs;
  final RxString area = "".obs;

  void onMainButtonPressed() {
    if (!isSmsCodeVisible.value) {
      // Validation Check: Empty fields
      if (phoneNumber.value.trim().isEmpty || email.value.trim().isEmpty) {
        Get.snackbar(
          "Information required",
          "You did not give your phone number or email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFA83F2D),
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
          borderRadius: 10,
        );
        return;
      }

      // Validation Check: Correct email format
      if (!GetUtils.isEmail(email.value.trim())) {
        Get.snackbar(
          "Invalid Email",
          "Please enter a correct email address.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFA83F2D),
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
          borderRadius: 10,
        );
        return;
      }

      // First press: Trigger SMS/Email code sending
      sendVerificationCode();
      isSmsCodeVisible.value = true;
    } else {
      // Second press: Complete signup
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
  }
}
