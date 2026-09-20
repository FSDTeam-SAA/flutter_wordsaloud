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
    final hasLocalCompletion = await _authStorageService
        .isTradesmanProfileCompleted(userId: userId);
    if (hasLocalCompletion) return true;

    final result = await _repo.dashboard();

    return result.fold<Future<bool>>(
      (fail) async {
        d_print.log(
          'Tradesman profile status check failed: ${fail.statusCode} ${fail.message}',
        );
        return false;
      },
      (success) async {
        final hasProfile = success.data.profile != null;
        if (hasProfile) {
          await _authStorageService.setTradesmanProfileCompleted(
            userId: userId,
          );
        }
        return hasProfile;
      },
    );
  }
}
