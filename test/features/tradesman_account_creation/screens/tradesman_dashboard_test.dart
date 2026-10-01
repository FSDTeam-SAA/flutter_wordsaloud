import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/dashboard_response_model.dart';
import 'package:aturservicett/features/tradesman_account_creation/screens/tradesman_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(Get.reset);

  testWidgets('shows the profile values saved during onboarding', (
    tester,
  ) async {
    final dashboard = TradesmanDashboardResponse(
      profile: Profile(
        user: User(firstName: 'Mariana', lastName: 'Scale'),
        mainSkill: 'Phone Tech',
        extraSkills: const ['Plumber', 'Electrician'],
        homeArea: 'Dhaka',
        travelRange: '5km - Local only',
        pitch: 'Fast and reliable service.',
        typicalRate: TypicalRate(amount: 200, unit: 'Per day'),
        isLive: true,
      ),
      tradesListed: 3,
      verification: Verification(
        status: 'pending',
        label: 'Pending Verification',
      ),
    );
    Get.put<TradesmanController>(_DashboardController(dashboard));

    await tester.pumpWidget(const GetMaterialApp(home: TradesmanDashboard()));
    await tester.pumpAndSettle();

    expect(find.text('Mariana S.'), findsOneWidget);
    expect(find.text('Phone Tech • Dhaka'), findsOneWidget);
    expect(find.text('MY PROFILE DETAILS'), findsOneWidget);
    expect(find.text('Phone Tech'), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);
    expect(find.text('Electrician'), findsOneWidget);
    expect(find.text(r'TT$200 per day'), findsOneWidget);
    expect(find.text('Fast and reliable service.'), findsOneWidget);
  });
}

class _DashboardController extends TradesmanController {
  _DashboardController(this.response);

  final TradesmanDashboardResponse response;

  @override
  Future<TradesmanDashboardResponse?> fetchDashboard() async {
    dashboardData.value = response;
    return response;
  }
}
