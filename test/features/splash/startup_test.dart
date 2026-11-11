import 'dart:async';

import 'package:aturservicett/core/network/models/network_success.dart';
import 'package:aturservicett/core/network/network_result.dart';
import 'package:aturservicett/core/services/auth_storage_service.dart';
import 'package:aturservicett/features/client_profile/controller/client_profile_controller.dart';
import 'package:aturservicett/features/home/screens/home_screen.dart';
import 'package:aturservicett/features/splash/screens/splash_screen.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/dashboard_response_model.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_all_tradesman_response_model.dart'
    show Tradesman;
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_skill_listed_count_response_model.dart';
import 'package:aturservicett/features/tradesman_account_creation/repositories/tradesman_repo.dart';
import 'package:aturservicett/features/tradesman_account_creation/screens/tradesman_dashboard.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _TradesmanController extends TradesmanController {
  late final skills = Completer<List<SkillModel>>();
  int skillRequests = 0;
  int dashboardRequests = 0;

  @override
  Future<List<SkillModel>> fetchSkillList() {
    skillRequests++;
    return skills.future;
  }

  @override
  Future<List<Tradesman>> fetchTradesmenForCounts({int limit = 500}) async =>
      [];

  @override
  Future<TradesmanDashboardResponse?> fetchDashboard() async {
    dashboardRequests++;
    throw StateError('The startup dashboard must be reused');
  }
}

class _ProfileController extends ClientProfileController {
  @override
  Future<Null> fetchClientProfile() async => null;
}

class _Repo implements TradesmanRepo {
  final response = Completer<TradesmanDashboardResponse>();
  int requests = 0;

  @override
  NetworkResult<TradesmanDashboardResponse> dashboard() async {
    requests++;
    return Right(
      ServerSuccess(
        data: await response.future,
        message: 'Loaded',
        statusCode: 200,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _finishSplashAnimation(WidgetTester tester) async {
  for (var frame = 0; frame < 40; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _TradesmanController controller;

  setUp(() {
    Get.testMode = true;
    FlutterSecureStorage.setMockInitialValues({});
    controller = _TradesmanController();
    Get.put<TradesmanController>(controller, permanent: true);
    Get.put<ClientProfileController>(_ProfileController(), permanent: true);
  });

  tearDown(Get.reset);

  Future<void> signIn(String role) => AuthStorageService().storeAuthData(
    accessToken: 'token',
    refreshToken: 'refresh',
    userId: 'user',
    role: role,
  );

  testWidgets('customer stays on splash until categories are ready', (
    tester,
  ) async {
    await signIn('client');
    await tester.pumpWidget(const GetMaterialApp(home: SplashScreen()));
    await tester.pump();
    await _finishSplashAnimation(tester);

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.text('No matches found.'), findsNothing);

    controller.skills.complete([SkillModel(skill: 'Plumber', icon: '🔧')]);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);
    expect(find.text('No matches found.'), findsNothing);
    expect(controller.skillRequests, 1);
  });

  testWidgets(
    'tradesman opens a populated dashboard without a second request',
    (tester) async {
      await signIn('tradesman');
      final repo = _Repo();
      Get.put<TradesmanRepo>(repo, permanent: true);
      await tester.pumpWidget(const GetMaterialApp(home: SplashScreen()));
      await tester.pump();
      await _finishSplashAnimation(tester);

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(TradesmanDashboard), findsNothing);

      repo.response.complete(
        TradesmanDashboardResponse(
          profile: Profile(
            user: User(firstName: 'Mariana', lastName: 'Scale'),
            isLive: true,
            mainSkill: 'Plumber',
            homeArea: 'Dhaka',
            travelRange: '5km',
            pitch: 'Reliable service',
            typicalRate: TypicalRate(amount: 200, unit: 'Per day'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TradesmanDashboard), findsOneWidget);
      expect(find.text('Mariana S.'), findsOneWidget);
      expect(find.text('Plumber • Dhaka'), findsOneWidget);
      expect(repo.requests, 1);
      expect(controller.dashboardRequests, 0);
    },
  );
}
