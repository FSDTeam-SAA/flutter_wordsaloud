import 'dart:developer' as d_print;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_wordsaloud/core/base/base_controller.dart';
import 'package:flutter_wordsaloud/core/services/auth_storage_service.dart';
import 'package:flutter_wordsaloud/core/services/session_service.dart';
import 'package:flutter_wordsaloud/features/auth/screens/role_selection_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_area_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_skill_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/dashboard_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/repositories/tradesman_repo.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tell_clients_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tradesman_dashboard.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/what_work_screen.dart';
import 'package:get/get.dart';

import '../../../core/network/services/multiple_form_data_manager.dart';

class TradesmanController extends BaseController {
  late final TradesmanRepo _tradesmanRepo = Get.find<TradesmanRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();
  final Rxn<TradesmanDashboardResponse> dashboardData =
      Rxn<TradesmanDashboardResponse>();

  Future<void> createTradesmanStep1(
    String mainSkill,
    List<String> extraSkills,
  ) async {
    clearError();
    setLoading(true);

    final request = TradesmanSkillRequestModel(
      mainSkill: mainSkill,
      extraSkills: extraSkills,
    );

    final result = await _tradesmanRepo.whatCanDo(request);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Create tradesman step 1 failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        d_print.log("Create tradesman step 1 success: ${success.data}");
        setLoading(false);
        Get.to(() => const WhatWorkScreen());
      },
    );
  }

  Future<void> createTradesmanStep2(String homeArea, String travelRange) async {
    clearError();
    setLoading(true);

    final request = TradesmanAreaRequestModel(
      homeArea: homeArea,
      travelRange: travelRange,
    );

    final result = await _tradesmanRepo.tradesmanArea(request);

    result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Create tradesman step 2 failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        d_print.log("Create tradesman step 2 success: ${success.data}");
        setLoading(false);
        Get.to(() => const TellClientsScreen());
      },
    );
  }

  Future<bool> createTradesmanStep3(
    String pitch,
    String amount,
    String unit,
    List<File> images,
  ) async {
    clearError();
    setLoading(true);
    _multiFormDataManager.clear();

    try {
      _multiFormDataManager.addTextData("pitch", pitch);
      _multiFormDataManager.addTextData("typicalRate[amount]", amount);
      _multiFormDataManager.addTextData("typicalRate[unit]", unit);
      d_print.log(
        'Create tradesman step 3 payload: pitch=$pitch, amount=$amount, unit=$unit',
      );

      if (images.isNotEmpty) {
        _multiFormDataManager.addImageFiles(images, key: "workPhotos");
      }

      final formRequest = await _multiFormDataManager.toFormDataAsync();
      final result = await _tradesmanRepo.tellClient(formRequest);

      return result.fold(
        (fail) {
          setError(fail.message);
          d_print.log('Create tradesman step 3 failed: ${fail.message}');
          return false;
        },
        (success) {
          d_print.log('Create tradesman step 3 success: ${success.message}');
          return true;
        },
      );
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Create tradesman step 3 error: $e');
      return false;
    } finally {
      _multiFormDataManager.clear();
      setLoading(false);
    }
  }

  Future<void> goLive({
    required String tradesmanName,
    required String tradesmanSkill,
    required String homeArea,
    String? profileImagePath,
  }) async {
    clearError();
    setLoading(true);
    final result = await _tradesmanRepo.goLive();

    await result.fold<Future<void>>(
      (fail) async {
        setError(fail.message);
        d_print.log("Go live failed: ${fail.message}");
        setLoading(false);
      },
      (success) async {
        d_print.log("Go live success: ${success.data}");
        await _authStorageService.setTradesmanProfileCompleted();
        setLoading(false);

        Get.offAll(
          () => TradesmanDashboard(
            tradesmanName: tradesmanName,
            tradesmanSkill: tradesmanSkill,
            homeArea: homeArea,
            profileImagePath: profileImagePath,
          ),
        );
      },
    );
  }

  Future<TradesmanDashboardResponse?> fetchDashboard() async {
    clearError();
    setLoading(true);
    final result = await _tradesmanRepo.dashboard();

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Fetch dashboard failed: ${fail.message}");
        setLoading(false);
        return null;
      },
      (success) {
        dashboardData.value = success.data;
        d_print.log("Fetch dashboard success: ${success.data}");
        setLoading(false);
        return success.data;
      },
    );
  }

  Future<bool> editProfile({
    required String pitch,
    required String amount,
    required String unit,
    required String mainSkill,
    required List<String> extraSkills,
    required String homeArea,
    required String travelRange,
    String? profileImagePath,
  }) async {
    clearError();
    setLoading(true);

    try {
      final normalizedAmount = amount.trim();
      final normalizedRateUnit = _normalizeRateUnitForApi(unit);
      final normalizedTravelRange = _normalizeTravelRangeForApi(travelRange);
      final normalizedExtraSkills = extraSkills
          .where((skill) => skill.trim().isNotEmpty)
          .toList();
      final formData = dio.FormData();
      formData.fields.addAll([
        MapEntry('pitch', pitch),
        MapEntry('rateAmount', normalizedAmount),
        MapEntry('rateUnit', normalizedRateUnit),
        MapEntry('mainSkill', mainSkill),
        MapEntry('extraSkills', jsonEncode(normalizedExtraSkills)),
        MapEntry('homeArea', homeArea),
        MapEntry('travelRange', normalizedTravelRange),
      ]);

      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        final imageFile = File(profileImagePath);
        if (await imageFile.exists()) {
          formData.files.add(
            MapEntry(
              'avatar',
              await dio.MultipartFile.fromFile(imageFile.path),
            ),
          );
        }
      }

      d_print.log(
        'Edit profile payload fields: ${formData.fields}, files: ${formData.files.map((file) => file.key).toList()}',
      );

      final result = await _tradesmanRepo.updateProfile(formData);
      return result.fold(
        (fail) {
          setError(fail.message);
          d_print.log("Edit profile failed: ${fail.message}");
          return false;
        },
        (success) {
          dashboardData.value = success.data;
          d_print.log("Edit profile success: ${success.data}");
          return true;
        },
      );
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Edit profile error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  String _normalizeRateUnitForApi(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.contains('hour')) return 'Per hour';
    if (normalized.contains('job')) return 'Per job';
    return 'Per day';
  }

  String _normalizeTravelRangeForApi(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.contains('t&t') ||
        normalized.contains('tt wide') ||
        normalized.contains('both island')) {
      return 'T&T wide';
    }
    if (normalized.contains('trinidad')) return 'Trinidad wide';
    return '5km - Local only';
  }

  Future<void> signOut() async {
    clearError();

    try {
      await _authStorageService.clearAuthData();
      dashboardData.value = null;

      if (Get.isRegistered<SessionService>()) {
        Get.find<SessionService>().clearToken();
      }

      Get.offAll(() => const RoleSelectionScreen());
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Sign out failed: $e');
    }
  }
}
