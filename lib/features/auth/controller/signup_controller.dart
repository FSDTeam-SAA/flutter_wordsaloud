import 'package:flutter_wordsaloud/features/auth/screens/sign_in_screen.dart';
import 'package:get/get.dart';

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
  }

  void completeSignup() {
    // Logic to finish signup
    Get.offAll(() => const SignInScreen());
  }
}
