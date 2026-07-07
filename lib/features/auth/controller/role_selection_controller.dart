import 'package:get/get.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_up_screen.dart';

class RoleSelectionController extends GetxController {
  // 0 for User, 1 for Tradesman, null for none
  final RxnInt selectedRole = RxnInt();

  void selectRole(int index) {
    selectedRole.value = index;
  }

  void onContinue() {
    if (selectedRole.value != null) {
      Get.to(() => const SignUpScreen());
    }
  }
}
