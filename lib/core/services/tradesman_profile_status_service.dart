import 'dart:developer' as d_print;

import 'package:aturservicett/features/tradesman_account_creation/repositories/tradesman_repo.dart';
import 'package:get/get.dart';

import 'auth_storage_service.dart';

class TradesmanProfileStatusService {
  TradesmanProfileStatusService({
    AuthStorageService? authStorageService,
    TradesmanRepo? tradesmanRepo,
  }) : _authStorageService = authStorageService ?? AuthStorageService(),
       _tradesmanRepo = tradesmanRepo;

  final AuthStorageService _authStorageService;
  final TradesmanRepo? _tradesmanRepo;

  TradesmanRepo get _repo => _tradesmanRepo ?? Get.find<TradesmanRepo>();

  Future<bool> hasCompletedProfile({String? userId}) async {
    // Registration creates an empty tradesman profile so it can enter the
    // verification queue. Profile existence therefore does not mean that the
    // user finished onboarding. Always use the backend's `isLive` state as the
    // source of truth; old versions of the app may have cached an incorrect
    // completion flag simply because the empty profile existed.
    final result = await _repo.dashboard();

    return result.fold<Future<bool>>(
      (fail) async {
        d_print.log(
          'Tradesman profile status check failed: ${fail.statusCode} ${fail.message}',
        );
        return false;
      },
      (success) async {
        final profile = success.data.profile;
        final rate = profile?.typicalRate;
        final isComplete =
            profile?.isLive == true &&
            (profile?.mainSkill?.trim().isNotEmpty ?? false) &&
            (profile?.homeArea?.trim().isNotEmpty ?? false) &&
            (profile?.travelRange?.trim().isNotEmpty ?? false) &&
            (profile?.pitch?.trim().isNotEmpty ?? false) &&
            (rate?.amount ?? 0) > 0 &&
            (rate?.unit?.trim().isNotEmpty ?? false);
        if (isComplete) {
          await _authStorageService.setTradesmanProfileCompleted(
            userId: userId,
          );
        } else {
          await _authStorageService.clearTradesmanProfileCompleted(
            userId: userId,
          );
        }
        return isComplete;
      },
    );
  }
}
