import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:get/get.dart';

class WhatWorkController extends GetxController {
  final TradesmanController _tradesmanController =
      Get.find<TradesmanController>();

  final RxString homeArea = ''.obs;

  // Travel range: 0 = 5km Local, 1 = Trinidad wide, 2 = T&T wide
  final RxnInt selectedRange = RxnInt();
  final RxString errorMessage = ''.obs;

  RxBool get isLoading => _tradesmanController.isLoading;

  final List<Map<String, String>> travelRanges = const [
    {'title': '5 km - Local only', 'subtitle': 'My immediate area'},
    {'title': 'Trinidad wide', 'subtitle': 'Anywhere in Trinidad'},
    {'title': 'T&T wide', 'subtitle': 'Both islands'},
  ];

  void selectRange(int index) {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
    selectedRange.value = index;
  }

  void onHomeAreaChanged(String value) {
    homeArea.value = value;
    if (errorMessage.value.isNotEmpty && value.trim().isNotEmpty) {
      errorMessage.value = '';
    }
  }

  Future<void> onContinuePressed() async {
    if (homeArea.value.trim().isEmpty) {
      errorMessage.value = 'You did not enter the home area.';
      return;
    }

    if (selectedRange.value == null) {
      errorMessage.value = 'Please select a travel range.';
      return;
    }

    errorMessage.value = '';

    await _tradesmanController.createTradesmanStep2(
      homeArea.value.trim(),
      travelRanges[selectedRange.value!]['title']!,
    );

    if (_tradesmanController.errorMessage.value.isNotEmpty) {
      errorMessage.value = _tradesmanController.errorMessage.value;
      _tradesmanController.clearError();
    }
  }
}
