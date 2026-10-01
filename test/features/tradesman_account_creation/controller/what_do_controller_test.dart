import 'dart:async';

import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/what_do_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_skill_listed_count_response_model.dart';
import 'package:aturservicett/features/tradesman_account_creation/screens/what_do_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late _FakeTradesmanController tradesmanController;

  setUp(() {
    Get.testMode = true;
    tradesmanController = _FakeTradesmanController();
    Get.put<TradesmanController>(tradesmanController);
  });

  tearDown(Get.reset);

  test('uses only categories returned by the backend', () async {
    tradesmanController.categories = [
      SkillModel(skill: 'Backend Trade', icon: '🛠️', isNew: true),
      SkillModel(skill: 'Another Trade'),
    ];
    final controller = WhatDoController();

    await controller.fetchCategories();

    expect(controller.skills.map((skill) => skill.name), [
      'Backend Trade',
      'Another Trade',
    ]);
    expect(controller.skills.first.image, '🛠️');
    expect(controller.skills.first.isNew, isTrue);
  });

  test('preserves selected category by name after an API refresh', () async {
    tradesmanController.categories = [
      SkillModel(skill: 'Plumber'),
      SkillModel(skill: 'Electrician'),
    ];
    final controller = WhatDoController();
    await controller.fetchCategories();
    controller.toggleSkill(1);

    tradesmanController.categories = [
      SkillModel(skill: 'Electrician'),
      SkillModel(skill: 'Plumber'),
      SkillModel(skill: 'Carpenter'),
    ];
    await controller.fetchCategories();

    expect(controller.mainSkillName, 'Electrician');
    expect(controller.selectMainIndex.value, 0);
  });

  testWidgets('shows red picked styles for main and additional trades', (
    tester,
  ) async {
    tradesmanController.categories = [
      SkillModel(skill: 'Plumber', icon: '🔧'),
      SkillModel(skill: 'Electrician', icon: '⚡'),
    ];

    await tester.pumpWidget(const GetMaterialApp(home: WhatDoScreen()));
    await tester.pumpAndSettle();

    final plumberCard = find.byKey(const ValueKey('trade-card-Plumber'));
    final electricianCard = find.byKey(
      const ValueKey('trade-card-Electrician'),
    );

    await tester.tap(plumberCard);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(electricianCard);
    await tester.pump(const Duration(milliseconds: 200));

    final controller = Get.find<WhatDoController>();
    expect(controller.mainSkillName, 'Plumber');
    expect(controller.isSelected(1), isTrue);

    final mainCard = tester.widget<AnimatedContainer>(plumberCard);
    final extraCard = tester.widget<AnimatedContainer>(electricianCard);
    final mainDecoration = mainCard.decoration! as BoxDecoration;
    final extraDecoration = extraCard.decoration! as BoxDecoration;
    final extraBorder = extraDecoration.border! as Border;

    expect(mainDecoration.color, const Color(0xFFA83F2D));
    expect(extraBorder.top.color, const Color(0xFFA83F2D));
    expect(extraBorder.top.width, 2);
    expect(find.byIcon(Icons.check), findsNWidgets(2));
  });

  testWidgets('shows categories when the API completes after first build', (
    tester,
  ) async {
    final apiResult = Completer<List<SkillModel>>();
    tradesmanController.pendingFetch = apiResult;

    await tester.pumpWidget(const GetMaterialApp(home: WhatDoScreen()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(const ValueKey('trade-card-Plumber')), findsNothing);

    apiResult.complete([
      SkillModel(skill: 'Plumber', icon: '🔧'),
      SkillModel(skill: 'Electrician', icon: '⚡'),
    ]);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('trade-card-Plumber')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('trade-card-Electrician')),
      findsOneWidget,
    );
  });
}

class _FakeTradesmanController extends TradesmanController {
  List<SkillModel> categories = const [];
  Completer<List<SkillModel>>? pendingFetch;

  @override
  Future<List<SkillModel>> fetchSkillList() async {
    isSkillListLoading.value = true;
    final pending = pendingFetch;
    if (pending != null) {
      final result = await pending.future;
      skillList.assignAll(result);
      isSkillListLoading.value = false;
      return result;
    }

    skillList.assignAll(categories);
    isSkillListLoading.value = false;
    return categories;
  }
}
