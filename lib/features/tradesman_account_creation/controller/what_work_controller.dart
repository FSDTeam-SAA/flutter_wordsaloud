import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tell_clients_screen.dart';

class WhatWorkController extends GetxController {
  final RxString homeArea = ''.obs;

  // Travel range: 0 = 5km Local, 1 = Trinidad wide, 2 = T&T wide
  final RxnInt selectedRange = RxnInt();

  final List<Map<String, String>> travelRanges = const [
    {'title': '5 km - Local only', 'subtitle': 'My immediate area'},
    {'title': 'Trinidad wide', 'subtitle': 'Anywhere in Trinidad'},
    {'title': 'T&T wide', 'subtitle': 'Both islands'},
  ];

  void selectRange(int index) {
    selectedRange.value = index;
  }

  void onContinuePressed() {
    if (homeArea.value.trim().isEmpty) {
      Get.snackbar(
        "Home Area Required",
        "You did not enter the home area.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFA83F2D),
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        borderRadius: 10,
      );
      return;
    }

    if (selectedRange.value == null) {
      Get.snackbar(
        "Travel Range Required",
        "Please select a travel range.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFA83F2D),
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        borderRadius: 10,
      );
      return;
    }

    Get.to(() => const TellClientsScreen());
  }
}

