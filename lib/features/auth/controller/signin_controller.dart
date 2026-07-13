import 'package:flutter_wordsaloud/features/home/screens/home_screen.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  final RxBool isCodeVisible = false.obs;
  final RxString email = ''.obs;
  final RxString code = ''.obs;
  final RxString emailError = ''.obs;
  final RxString codeError = ''.obs;

  void sendCode() {
    if (email.value.trim().isEmpty) {
      emailError.value = 'Email address is required.';
      return;
    }

    if (!GetUtils.isEmail(email.value.trim())) {
      emailError.value = 'Please enter a correct email address.';
      return;
    }

    emailError.value = '';
    isCodeVisible.value = true;
  }

  void login() {
    if (!isCodeVisible.value) {
      sendCode();
      return;
    }

    if (code.value.trim().length < 6) {
      codeError.value = 'Verification code is required.';
      return;
    }

    codeError.value = '';
    Get.offAll(() => const HomeScreen());
  }
}
