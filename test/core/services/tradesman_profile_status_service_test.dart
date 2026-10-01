import 'package:aturservicett/core/network/models/network_failure.dart';
import 'package:aturservicett/core/network/models/network_success.dart';
import 'package:aturservicett/core/network/network_result.dart';
import 'package:aturservicett/core/services/auth_storage_service.dart';
import 'package:aturservicett/core/services/tradesman_profile_status_service.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/dashboard_response_model.dart';
import 'package:aturservicett/features/tradesman_account_creation/repositories/tradesman_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const userId = 'tradesman-1';

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('empty registration profile does not count as completed', () async {
    final storage = AuthStorageService(storage: const FlutterSecureStorage());
    await storage.setTradesmanProfileCompleted(userId: userId);

    final service = TradesmanProfileStatusService(
      authStorageService: storage,
      tradesmanRepo: _DashboardRepo(
        TradesmanDashboardResponse(profile: Profile(isLive: false)),
      ),
    );

    expect(await service.hasCompletedProfile(userId: userId), isFalse);
    expect(await storage.isTradesmanProfileCompleted(userId: userId), isFalse);
  });

  test('live backend profile counts as completed and is cached', () async {
    final storage = AuthStorageService(storage: const FlutterSecureStorage());
    final service = TradesmanProfileStatusService(
      authStorageService: storage,
      tradesmanRepo: _DashboardRepo(
        TradesmanDashboardResponse(
          profile: Profile(
            isLive: true,
            mainSkill: 'Plumber',
            homeArea: 'San Fernando',
            travelRange: '5km - Local only',
            pitch: 'Experienced residential plumber.',
            typicalRate: TypicalRate(amount: 200, unit: 'Per day'),
          ),
        ),
      ),
    );

    expect(await service.hasCompletedProfile(userId: userId), isTrue);
    expect(await storage.isTradesmanProfileCompleted(userId: userId), isTrue);
  });

  test('live but incomplete backend profile returns to onboarding', () async {
    final storage = AuthStorageService(storage: const FlutterSecureStorage());
    final service = TradesmanProfileStatusService(
      authStorageService: storage,
      tradesmanRepo: _DashboardRepo(
        TradesmanDashboardResponse(
          profile: Profile(
            isLive: true,
            mainSkill: 'Plumber',
            homeArea: 'San Fernando',
            travelRange: '5km - Local only',
          ),
        ),
      ),
    );

    expect(await service.hasCompletedProfile(userId: userId), isFalse);
  });
}

class _DashboardRepo implements TradesmanRepo {
  _DashboardRepo(this.response);

  final TradesmanDashboardResponse response;

  @override
  NetworkResult<TradesmanDashboardResponse> dashboard() async {
    final Either<NetworkFailure, NetworkSuccess<TradesmanDashboardResponse>>
    result = Right(
      ServerSuccess(
        data: response,
        message: 'Dashboard fetched',
        statusCode: 200,
      ),
    );
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
