import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aturservicett/features/auth/screens/sign_up_screen.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  static const _offerNoteSeenKey = 'role_selection_offer_note_seen';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 0 for User, 1 for Tradesman, null for none
  final RxnInt selectedRole = RxnInt();
  final RxBool showOfferNote = false.obs;

  Future<void> loadOfferNoteVisibility() async {
    final hasSeenNote = await _storage.read(key: _offerNoteSeenKey);
    final shouldShow = hasSeenNote != 'true';
    showOfferNote.value = shouldShow;

    if (shouldShow) {
      await _storage.write(key: _offerNoteSeenKey, value: 'true');
    }
  }

  void selectRole(int index) {
    selectedRole.value = index;
  }

  void onContinue() {
    if (selectedRole.value != null) {
      Get.to(() => const SignUpScreen());
      return;
    }

    Get.snackbar(
      'Select a role',
      'Choose client or tradesman to continue.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFA83F2D),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
