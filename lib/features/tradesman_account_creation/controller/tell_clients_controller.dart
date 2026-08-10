import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_wordsaloud/features/auth/controller/auth_controller.dart';
import 'package:flutter_wordsaloud/features/auth/controller/signup_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/what_do_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/what_work_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/you_are_live_screen.dart';

class TellClientsController extends GetxController {
  final TradesmanController _tradesmanController =
      Get.find<TradesmanController>();

  final RxString pitch = ''.obs;
  final RxString pitchError = ''.obs;
  final RxString rate = ''.obs;
  final RxString rateError = ''.obs;
  final RxString apiError = ''.obs;
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
      if (apiError.value.isNotEmpty) {
        apiError.value = '';
      }
    }
  }

  void onRateChanged(String value) {
    rate.value = value;
    if (rateError.value.isNotEmpty && value.trim().isNotEmpty) {
      rateError.value = '';
    }
    if (apiError.value.isNotEmpty) {
      apiError.value = '';
    }
  }

  void selectRateUnit(String value) {
    rateUnit.value = value;
  }

  RxBool get isLoading => _tradesmanController.isLoading;

  Future<void> pickPhotos() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      workPhotos.addAll(images);
    }
  }

  bool get canContinue => pitch.value.trim().isNotEmpty;

  Future<void> onContinuePressed() async {
    if (!canContinue) {
      pitchError.value = 'Please enter your pitch description.';
      return;
    }

    if (rate.value.trim().isEmpty) {
      rateError.value = 'Please enter your typical rate.';
      return;
    }

    final parsedRate = num.tryParse(rate.value.trim());
    if (parsedRate == null || parsedRate <= 0) {
      rateError.value = 'Please enter a valid typical rate.';
      return;
    }

    pitchError.value = '';
    rateError.value = '';
    apiError.value = '';

    final images = workPhotos.map((photo) => File(photo.path)).toList();
    final isSuccess = await _tradesmanController.createTradesmanStep3(
      pitch.value.trim(),
      parsedRate.toString(),
      rateUnit.value,
      images,
    );

    if (!isSuccess) {
      apiError.value = _tradesmanController.errorMessage.value;
      _tradesmanController.clearError();
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

    if (fullName.isEmpty && Get.isRegistered<AuthController>()) {
      fullName = Get.find<AuthController>().currentUserName.value.trim();
    }

    if (fullName.isEmpty) {
      final profile = await _tradesmanController.fetchClientProfile();
      fullName = _displayProfileName(
        name: profile?.name,
        firstName: profile?.firstName,
        lastName: profile?.lastName,
      );
    }

    String tradesmanSkill = '';
    List<String> extraTrades = const [];
    if (Get.isRegistered<WhatDoController>()) {
      final whatDoController = Get.find<WhatDoController>();
      tradesmanSkill = whatDoController.mainSkillName.trim();
      extraTrades = whatDoController.selectExtraIndices
          .map((index) => whatDoController.skills[index].name)
          .toList();
    }

    String homeArea = '';
    if (Get.isRegistered<WhatWorkController>()) {
      homeArea = Get.find<WhatWorkController>().homeArea.value.trim();
    }

    Get.to(
      () => YouAreLiveScreen(
        tradesmanName: fullName.isNotEmpty ? fullName : 'Tradesman',
        tradesmanSkill: tradesmanSkill,
        extraTrades: extraTrades,
        homeArea: homeArea,
      ),
    );
  }

  String _displayProfileName({
    String? name,
    String? firstName,
    String? lastName,
  }) {
    final explicitName = name?.trim() ?? '';
    if (explicitName.isNotEmpty) return explicitName;

    return [
      firstName?.trim() ?? '',
      lastName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
