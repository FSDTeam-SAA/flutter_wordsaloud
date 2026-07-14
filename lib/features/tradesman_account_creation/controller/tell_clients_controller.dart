import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_wordsaloud/features/auth/controller/signup_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/what_do_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/what_work_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/you_are_live_screen.dart';

class TellClientsController extends GetxController {
  final RxString pitch = ''.obs;
  final RxString pitchError = ''.obs;
  final RxString rate = ''.obs;
  final RxString rateUnit = 'Per day'.obs;
  final RxList<XFile> workPhotos = <XFile>[].obs;

  final int maxPitchChars = 140;

  final List<String> rateUnits = const ['Per day', 'Per hour', 'Per job'];

  void onPitchChanged(String value) {
    if (value.length <= maxPitchChars) {
      pitch.value = value;
      if (pitchError.value.isNotEmpty && value.trim().isNotEmpty) {
        pitchError.value = '';
      }
    }
  }

  void onRateChanged(String value) {
    rate.value = value;
  }

  void selectRateUnit(String value) {
    rateUnit.value = value;
  }

  Future<void> pickPhotos() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      workPhotos.addAll(images);
    }
  }

  bool get canContinue => pitch.value.trim().isNotEmpty;

  void onContinuePressed() {
    if (!canContinue) {
      pitchError.value = 'Please enter your pitch description.';
      return;
    }

    // Read the name from SignupController (still in memory)
    String fullName = '';
    if (Get.isRegistered<SignupController>()) {
      final signupCtrl = Get.find<SignupController>();
      final first = signupCtrl.firstName.value.trim();
      final last = signupCtrl.lastName.value.trim();
      fullName = [first, last].where((s) => s.isNotEmpty).join(' ');
    }

    String tradesmanSkill = '';
    if (Get.isRegistered<WhatDoController>()) {
      tradesmanSkill = Get.find<WhatDoController>().mainSkillName.trim();
    }

    String homeArea = '';
    if (Get.isRegistered<WhatWorkController>()) {
      homeArea = Get.find<WhatWorkController>().homeArea.value.trim();
    }

    final String? firstPhotoPath = workPhotos.isNotEmpty ? workPhotos.first.path : null;

    Get.to(
      () => YouAreLiveScreen(
        tradesmanName: fullName.isNotEmpty ? fullName : 'Tradesman',
        tradesmanSkill: tradesmanSkill,
        homeArea: homeArea,
        profileImagePath: firstPhotoPath,
      ),
    );
  }
}
