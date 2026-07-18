import 'dart:developer' as d_print;
import 'dart:io';

import 'package:flutter_wordsaloud/core/base/base_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_area_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_skill_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/repositories/tradesman_repo.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tell_clients_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/what_work_screen.dart';
import 'package:get/get.dart';

import '../../../core/network/services/multiple_form_data_manager.dart';

class TradesmanController extends BaseController {
  late final TradesmanRepo _tradesmanRepo = Get.find<TradesmanRepo>();
  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

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
      _multiFormDataManager.addTextData("amount", amount);
      _multiFormDataManager.addTextData("unit", unit);

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
}
