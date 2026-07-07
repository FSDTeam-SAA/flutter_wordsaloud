import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  // 0 for User, 1 for Tradesman, null for none
  final RxnInt selectedRole = RxnInt();

  void selectRole(int index) {
    selectedRole.value = index;
  }

  void onContinue() {
    if (selectedRole.value != null) {
      // Navigate to Signup or Login based on logic
      print("Role selected: ${selectedRole.value}");
    }
  }
}
