import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_skill_listed_count_response_model.dart';

class Skill {
  final String name;
  final String image;
  final bool isNew;

  const Skill({required this.name, required this.image, this.isNew = false});
}

class WhatDoController extends GetxController {
  final TradesmanController _tradesmanController =
      Get.find<TradesmanController>();

  static const String _defaultSkillImage =
      'assets/images/project-manager_8741633 1.png';

  static const Map<String, String> _localSkillImages = {
    'phone tech': 'assets/images/fi_5060325.png',
    'computer tech': 'assets/images/fi_10528057.png',
    'plumber': 'assets/images/fi_6342703.png',
    'electrician': 'assets/images/fi_9781304.png',
    'appliance': 'assets/images/fi_2012957.png',
    'appliance fix': 'assets/images/fi_2012957.png',
    'joinery': 'assets/images/fi_14106303.png',
    'ac tech': 'assets/images/fi_7969720.png',
    'painter': 'assets/images/fi_1995467.png',
    'maid service': 'assets/images/fi_15551378.png',
    'caterer': 'assets/images/fi_4490380.png',
    'tile man': 'assets/images/fi_11932525.png',
    'tile men': 'assets/images/fi_11932525.png',
    'glass man': 'assets/images/fi_896123.png',
    'glass men': 'assets/images/fi_896123.png',
    'mason': 'assets/images/fi_18029670.png',
    'carpenter': 'assets/images/fi_12479483.png',
    'welder/gate': 'assets/images/fi_9439147.png',
    'fabricator/welder': 'assets/images/fi_9439147.png',
    'pool cleaner': 'assets/images/fi_15551378.png',
    'tree cutter': 'assets/images/fi_6327310.png',
    'landscaper': 'assets/images/fi_10033506.png',
    'roofer': 'assets/images/fi_14620736.png',
    'mechanic': 'assets/images/mechanic.png',
    'auto body': 'assets/images/fi_6332022.png',
    'contractor': 'assets/images/fi_4490380.png',
  };

  final RxList<Skill> skills = <Skill>[].obs;

  // Index of the selected main skill (null if none selected)
  final RxnInt selectMainIndex = RxnInt();

  // Indices of the selected extra skills (up to 2)
  final RxList<int> selectExtraIndices = <int>[].obs;
  final RxString errorMessage = ''.obs;
  final RxString categoriesError = ''.obs;

  RxBool get isLoading => _tradesmanController.isLoading;
  RxBool get isCategoriesLoading => _tradesmanController.isSkillListLoading;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  int get totalSelectedCount =>
      (selectMainIndex.value != null ? 1 : 0) + selectExtraIndices.length;

  String get mainSkillName {
    final index = selectMainIndex.value;
    if (index == null || index < 0 || index >= skills.length) return '';
    return skills[index].name;
  }

  Future<void> fetchCategories() async {
    categoriesError.value = '';
    final apiSkills = await _tradesmanController.fetchSkillList();

    final categories = apiSkills
        .where((skill) => skill.skill?.trim().isNotEmpty ?? false)
        .map(_skillFromApi)
        .toList();

    if (categories.isEmpty) {
      categoriesError.value = _tradesmanController.errorMessage.value.isNotEmpty
          ? _tradesmanController.errorMessage.value
          : 'No trade categories are available right now.';
      _tradesmanController.clearError();
      return;
    }

    _replaceSkillsPreservingSelection(categories);
    _tradesmanController.clearError();
  }

  Skill _skillFromApi(SkillModel skill) {
    final name = skill.skill!.trim();
    final apiIcon = skill.icon?.trim() ?? '';
    return Skill(
      name: name,
      image: apiIcon.isNotEmpty
          ? apiIcon
          : _localSkillImages[name.toLowerCase()] ?? _defaultSkillImage,
      isNew: skill.isNew,
    );
  }

  void _replaceSkillsPreservingSelection(List<Skill> categories) {
    final selectedMain = mainSkillName.toLowerCase();
    final selectedExtras = selectExtraIndices
        .where((index) => index >= 0 && index < skills.length)
        .map((index) => skills[index].name.toLowerCase())
        .toSet();

    skills.assignAll(categories);

    final mainIndex = skills.indexWhere(
      (skill) => skill.name.toLowerCase() == selectedMain,
    );
    selectMainIndex.value = mainIndex >= 0 ? mainIndex : null;
    selectExtraIndices.assignAll([
      for (var index = 0; index < skills.length; index++)
        if (selectedExtras.contains(skills[index].name.toLowerCase()) &&
            index != selectMainIndex.value)
          index,
    ]);
  }

  bool isSelected(int index) {
    return selectMainIndex.value == index || selectExtraIndices.contains(index);
  }

  bool isMain(int index) {
    return selectMainIndex.value == index;
  }

  void toggleSkill(int index) {
    if (index < 0 || index >= skills.length) return;

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
    if (skills.isEmpty) {
      categoriesError.value = 'Load the trade categories before continuing.';
      return;
    }

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
