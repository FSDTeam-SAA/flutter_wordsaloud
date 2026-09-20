import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';

class Skill {
  final String name;
  final String image;
  final bool isNew;

  const Skill({required this.name, required this.image, this.isNew = false});
}

class WhatDoController extends GetxController {
  final TradesmanController _tradesmanController =
      Get.find<TradesmanController>();

  final List<Skill> skills = const [
    Skill(
      name: 'Phone Tech',
      image: 'assets/images/fi_5060325.png',
      isNew: true,
    ),
    Skill(
      name: 'Computer Tech',
      image: 'assets/images/fi_10528057.png',
      isNew: true,
    ),
    Skill(name: 'Plumber', image: 'assets/images/fi_6342703.png'),
    Skill(name: 'Electrician', image: 'assets/images/fi_9781304.png'),
    Skill(name: 'Appliance Fix', image: 'assets/images/fi_2012957.png'),
    Skill(name: 'Joinery', image: 'assets/images/fi_14106303.png', isNew: true),
    Skill(name: 'AC Tech', image: 'assets/images/fi_7969720.png'),
    Skill(name: 'Painter', image: 'assets/images/fi_1995467.png'),
    Skill(name: 'Maid Service', image: 'assets/images/fi_15551378.png'),
    Skill(name: 'Caterer', image: 'assets/images/fi_4490380.png', isNew: true),
    Skill(
      name: 'Tile Men',
      image: 'assets/images/fi_11932525.png',
      isNew: true,
    ),
    Skill(name: 'Glass Men', image: 'assets/images/fi_896123.png'),
    Skill(name: 'Mason', image: 'assets/images/fi_18029670.png'),
    Skill(name: 'Carpenter', image: 'assets/images/fi_12479483.png'),
    Skill(name: 'Fabricator/Welder', image: 'assets/images/fi_9439147.png'),
    Skill(name: 'Pool Cleaner', image: 'assets/images/fi_15551378.png'),
    Skill(name: 'Tree Cutter', image: 'assets/images/fi_6327310.png'),
    Skill(name: 'Landscaper', image: 'assets/images/fi_10033506.png'),
    Skill(name: 'Roofer', image: 'assets/images/fi_14620736.png'),
    Skill(name: 'Mechanic', image: 'assets/images/mechanic.png'),
    Skill(name: 'Auto Body', image: 'assets/images/fi_6332022.png'),
    Skill(name: 'Contractor', image: 'assets/images/fi_4490380.png'),
  ];

  // Index of the selected main skill (null if none selected)
  final RxnInt selectMainIndex = RxnInt();

  // Indices of the selected extra skills (up to 2)
  final RxList<int> selectExtraIndices = <int>[].obs;
  final RxString errorMessage = ''.obs;

  RxBool get isLoading => _tradesmanController.isLoading;

  int get totalSelectedCount =>
      (selectMainIndex.value != null ? 1 : 0) + selectExtraIndices.length;

  String get mainSkillName =>
      selectMainIndex.value != null ? skills[selectMainIndex.value!].name : "";

  bool isSelected(int index) {
    return selectMainIndex.value == index || selectExtraIndices.contains(index);
  }

  bool isMain(int index) {
    return selectMainIndex.value == index;
  }

  void toggleSkill(int index) {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }

    if (selectMainIndex.value == index) {
      // Tapped the main skill -> Deselect it
      if (selectExtraIndices.isNotEmpty) {
        // Promote the first extra to Main
        selectMainIndex.value = selectExtraIndices.removeAt(0);
      } else {
        selectMainIndex.value = null;
      }
    } else if (selectExtraIndices.contains(index)) {
      // Tapped a selected extra skill -> Deselect it
      selectExtraIndices.remove(index);
    } else {
      // Tapping an unselected skill
      if (selectMainIndex.value == null) {
        // 1. If no main, it becomes main
        selectMainIndex.value = index;
      } else if (selectExtraIndices.length < 2) {
        // 2. If main is selected, add to extras if space available
        selectExtraIndices.add(index);
      } else {
        // 3. Already selected 3 skills (1 main + 2 extras)
        Get.snackbar(
          "Selection limit reached",
          "You can select 1 main and up to 2 extra skills.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFA83F2D),
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
          borderRadius: 10,
        );
      }
    }
  }

  Future<void> onContinuePressed() async {
    if (selectMainIndex.value == null) {
      errorMessage.value = 'Please select your main skill.';
      return;
    }

    errorMessage.value = '';

    await _tradesmanController.createTradesmanStep1(
      mainSkillName,
      selectExtraIndices.map((index) => skills[index].name).toList(),
    );

    if (_tradesmanController.errorMessage.value.isNotEmpty) {
      errorMessage.value = _tradesmanController.errorMessage.value;
      _tradesmanController.clearError();
    }
  }
}
