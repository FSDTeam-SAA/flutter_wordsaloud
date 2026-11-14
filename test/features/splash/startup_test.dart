import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aturservicett/features/auth/controller/auth_controller.dart';
import 'package:aturservicett/features/auth/models/request/sign_in_request_model.dart';
import 'package:aturservicett/features/auth/models/response/login_response_model.dart';
import 'package:aturservicett/features/auth/repositories/auth_repo.dart';
import 'package:aturservicett/features/home/controller/home_controller.dart';

import 'package:aturservicett/core/network/models/network_success.dart';
import 'package:aturservicett/core/network/network_result.dart';
import 'package:aturservicett/core/services/auth_storage_service.dart';
import 'package:aturservicett/features/client_profile/controller/client_profile_controller.dart';
import 'package:aturservicett/features/home/screens/home_screen.dart';
import 'package:aturservicett/features/splash/screens/splash_screen.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/dashboard_response_model.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_client_profile_response_model.dart';
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
  final profileResponse = Completer<GetClientProfileResponseModel>();
  int requests = 0;
  int profileRequests = 0;

  @override
  NetworkResult<GetClientProfileResponseModel> getClientProfile() async {
    profileRequests++;
    return Right(
      ServerSuccess(
        data: await profileResponse.future,
        message: 'Loaded',
        statusCode: 200,
      ),
    );
  }

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

class _AuthRepo implements AuthRepository {
  _AuthRepo(this.role);
  final String role;

  @override
  NetworkResult<LoginResponseModel> login(SignInRequestModel request) async =>
      Right(
        ServerSuccess(
          data: LoginResponseModel(
            id: 'user',
            role: role,
            accessToken: 'token',
            refreshToken: 'refresh',
          ),
          message: 'Signed in',
          statusCode: 200,
        ),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _finishSplashAnimation(WidgetTester tester) async {
  for (var frame = 0; frame < 40; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

TradesmanDashboardResponse _dashboard() => TradesmanDashboardResponse(
  profile: Profile(
    user: User(firstName: 'Mariana', lastName: 'Scale'),
    isLive: true,
    mainSkill: 'Plumber',
    homeArea: 'Dhaka',
    travelRange: '5km',
    pitch: 'Reliable service',
    typicalRate: TypicalRate(amount: 200, unit: 'Per day'),
  ),
);

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

  test('concurrent category requests all wait for the initial data', () async {
    final home = HomeController();
    var secondFinished = false;
    final first = home.fetchSkillList();
    final second = home.refreshCategoryListOnly().then(
      (_) => secondFinished = true,
    );
    await Future<void>.delayed(Duration.zero);
    expect(secondFinished, isFalse);
    expect(home.isLoadingSkills.value, isTrue);
    controller.skills.complete([SkillModel(skill: 'Plumber')]);
    await Future.wait([first, second]);
    expect(home.categories.single.name, 'Plumber');
    expect(controller.skillRequests, 1);
    expect(home.isLoadingSkills.value, isFalse);
  });

  testWidgets('login waits for categories before opening the customer home', (
    tester,
  ) async {
    Get.put<AuthRepository>(_AuthRepo('client'), permanent: true);
    final auth = Get.put(AuthController(), permanent: true);
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: Text('Sign in'))),
    );
    final login = auth.login(
      email: 'test@example.com',
      verificationCode: '123456',
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    controller.skills.complete([SkillModel(skill: 'Plumber', icon: '🔧')]);
    await tester.pump();
    await login;
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);
    expect(find.text('No matches found.'), findsNothing);
    expect(controller.skillRequests, 1);
  });

  testWidgets('a previous search cannot hide preloaded home categories', (
    tester,
  ) async {
    final home = Get.put(HomeController());
    home.searchQuery.value = 'Unmatched old search';
    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeScreen(
          initialCategories: [TradeCategory(name: 'Plumber', image: '🔧')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Plumber'), findsOneWidget);
    expect(find.text('No matches found.'), findsNothing);
    expect(controller.skillRequests, 0);
  });

  testWidgets('tradesman login opens the already loaded dashboard', (
    tester,
  ) async {
    Get.put<AuthRepository>(_AuthRepo('tradesman'), permanent: true);
    final repo = Get.put<TradesmanRepo>(_Repo(), permanent: true) as _Repo;
    final auth = Get.put(AuthController(), permanent: true);
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: Text('Sign in'))),
    );
    final login = auth.login(
      email: 'test@example.com',
      verificationCode: '123456',
    );
    await tester.pumpAndSettle();
    expect(find.byType(TradesmanDashboard), findsNothing);
    repo.response.complete(_dashboard());
    await tester.pump();
    await login;
    await tester.pumpAndSettle();
    expect(find.text('Mariana S.'), findsOneWidget);
    expect(find.text('Plumber • Dhaka'), findsOneWidget);
    expect(repo.requests, 1);
    expect(controller.dashboardRequests, 0);
  });

  testWidgets('switching to customer mode reuses the prepared categories', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(home: TradesmanDashboard(initialDashboard: _dashboard())),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Switch to customer view'), 400);
    await tester.tap(find.text('Switch to customer view'));
    await tester.pump();
    expect(find.byType(HomeScreen), findsNothing);
    controller.skills.complete([SkillModel(skill: 'Plumber', icon: '🔧')]);
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);
    expect(controller.skillRequests, 1);
  });

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

  testWidgets('customer profile is ready on the first home frame', (
    tester,
  ) async {
    await Get.delete<ClientProfileController>(force: true);
    final repo = _Repo();
    Get.put<TradesmanRepo>(repo, permanent: true);
    await signIn('client');
    await tester.pumpWidget(const GetMaterialApp(home: SplashScreen()));
    await tester.pump();
    controller.skills.complete([SkillModel(skill: 'Plumber', icon: '🔧')]);
    await _finishSplashAnimation(tester);

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(repo.profileRequests, 1);

    repo.profileResponse.complete(
      GetClientProfileResponseModel(
        name: 'Alex',
        phoneNumber: '123456789',
        area: 'Dhaka',
      ),
    );
    // Inspect the first frame that builds HomeScreen, before any later fetch.
    for (
      var frame = 0;
      frame < 20 && find.byType(HomeScreen).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('U'), findsNothing);
    expect(find.text('Plumber'), findsOneWidget);
    expect(Get.find<ClientProfileController>().hasRequiredProfileInfo, isTrue);
    await tester.pumpAndSettle();
    expect(repo.profileRequests, 1);
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
