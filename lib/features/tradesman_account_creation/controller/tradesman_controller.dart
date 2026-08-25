import 'dart:developer' as d_print;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_wordsaloud/core/base/base_controller.dart';
import 'package:flutter_wordsaloud/core/services/auth_storage_service.dart';
import 'package:flutter_wordsaloud/core/services/session_service.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_in_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/add_inquiry_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/add_review_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_area_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_skill_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/dashboard_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_advertise_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_all_tradesman_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_client_profile_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_skill_listed_count_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_specific_tradesman_response_model.dart';
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
  final Rxn<GetClientProfileResponseModel> getProfile =
      Rxn<GetClientProfileResponseModel>();
  final Rxn<GetSpecificTradesmanResponseModel> getSpecificTradesman =
      Rxn<GetSpecificTradesmanResponseModel>();
  final RxList<SkillModel> skillList = <SkillModel>[].obs;
  final RxList<Tradesman> allTradesman = <Tradesman>[].obs;
  final RxList<Advertisement> advertisements = <Advertisement>[].obs;
  final RxBool isSkillListLoading = false.obs;
  final RxBool isTradesmanLoading = false.obs;
  final RxBool isSingleTradesmanLoading = false.obs;
  final RxBool isAdvertiseLoading = false.obs;

  Future<void> createTradesmanStep1(
    String mainSkill,
    List<String> extraSkills,
  ) async {
    clearError();
    setLoading(true);

    final request = TradesmanSkillRequestModel(
      mainSkill: _normalizeSkillForApi(mainSkill),
      extraSkills: extraSkills.map(_normalizeSkillForApi).toList(),
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

  Future<bool> addReview({
    required String tradesmanId,
    required int rating,
    required String ratingLabel,
    required String reviewText,
  }) async {
    clearError();
    if (tradesmanId.trim().isEmpty) {
      setError('Tradesman profile not found. Please try again.');
      return false;
    }

    setLoading(true);

    final request = AddReviewRequestModel(
      rating: rating,
      ratingLabel: ratingLabel,
      reviewText: reviewText,
    );

    final result = await _tradesmanRepo.addReview(request, tradesmanId);

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Add review failed: ${fail.message}");
        setLoading(false);
        return false;
      },
      (success) {
        d_print.log("Add review success: ${success.data}");
        setLoading(false);
        return true;
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
      final normalizedAmount = amount.trim();
      final normalizedRateUnit = _normalizeRateUnitForApi(unit);

      _multiFormDataManager.addTextData("pitch", pitch);
      _multiFormDataManager.addTextData("rateAmount", normalizedAmount);
      _multiFormDataManager.addTextData("rateUnit", normalizedRateUnit);
      d_print.log(
        'Create tradesman step 3 payload: pitch=$pitch, amount=$normalizedAmount, unit=$normalizedRateUnit',
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

  Future<bool> updateClientProfile(
    String name,
    String phoneNumber,
    String area,
    File? image,
  ) async {
    clearError();
    setLoading(true);
    _multiFormDataManager.clear();

    try {
      _multiFormDataManager.addTextData("name", name);
      _multiFormDataManager.addTextData("phoneNumber", phoneNumber);
      _multiFormDataManager.addTextData("area", area);

      if (image != null) {
        _multiFormDataManager.addFile(image, key: "profileImage");
      }

      final formRequest = await _multiFormDataManager.toFormDataAsync();
      final result = await _tradesmanRepo.updateClientProfile(formRequest);

      return result.fold(
        (fail) {
          setError(fail.message);
          d_print.log('Update client profile failed: ${fail.message}');
          return false;
        },
        (success) {
          d_print.log('Update client profile success: ${success.message}');
          return true;
        },
      );
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Update client profile error: $e');
      return false;
    } finally {
      _multiFormDataManager.clear();
      setLoading(false);
    }
  }

  Future<void> goLive({
    required String tradesmanName,
    required String tradesmanSkill,
    List<String> extraTrades = const [],
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
            extraTrades: extraTrades,
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

  Future<GetClientProfileResponseModel?> fetchClientProfile() async {
    clearError();
    setLoading(true);
    final result = await _tradesmanRepo.getClientProfile();

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Fetch client profile failed: ${fail.message}");
        setLoading(false);
        return null;
      },
      (success) {
        getProfile.value = success.data;
        d_print.log("Fetch client profile success: ${success.data}");
        setLoading(false);
        return success.data;
      },
    );
  }

  Future<List<SkillModel>> fetchSkillList() async {
    clearError();
    isSkillListLoading.value = true;
    final result = await _tradesmanRepo.getSkillList();

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Fetch skill list failed: ${fail.message}");
        isSkillListLoading.value = false;
        return skillList;
      },
      (success) {
        skillList.assignAll(success.data);
        d_print.log("Fetch skill list success: ${success.data}");
        isSkillListLoading.value = false;
        return success.data;
      },
    );
  }

  Future<GetSpecificTradesmanResponseModel?> getSingleTradesman(
    String tradesmanId,
  ) async {
    clearError();
    if (tradesmanId.trim().isEmpty) return null;

    isSingleTradesmanLoading.value = true;
    getSpecificTradesman.value = null;
    final result = await _tradesmanRepo.getSpecifiedTradesman(tradesmanId);

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Fetch single tradesman failed: ${fail.message}");
        isSingleTradesmanLoading.value = false;
        return null;
      },
      (success) {
        getSpecificTradesman.value = success.data;
        _syncCachedTradesman(success.data);
        d_print.log("Fetch single tradesman success: ${success.data}");
        isSingleTradesmanLoading.value = false;
        return success.data;
      },
    );
  }

  void _syncCachedTradesman(GetSpecificTradesmanResponseModel tradesman) {
    final profile = tradesman.profile;
    final index = allTradesman.indexWhere((item) => item.id == profile.id);
    if (index == -1) return;

    allTradesman[index] = allTradesman[index].copyWith(
      extraSkills: profile.extraSkills,
      pitch: profile.pitch,
      verificationStatus: profile.verificationStatus,
      isLive: profile.isLive,
      isVip: profile.isVip,
      ratingAverage: profile.ratingAverage,
      ratingCount: profile.ratingCount > 0
          ? profile.ratingCount
          : tradesman.reviews.length,
      jobsCount: profile.jobsCount,
      workPhotos: profile.workPhotos,
      mainSkill: profile.mainSkill,
      homeArea: profile.homeArea,
      travelRange: profile.travelRange,
    );
  }

  Future<List<Tradesman>> fetchTradesman({
    required String skill,
    String search = '',
    String area = '',
    String sort = 'rating',
    int page = 1,
    int limit = 20,
  }) async {
    clearError();
    isTradesmanLoading.value = true;
    allTradesman.clear();
    final normalizedSkill = _normalizeSkillForApi(skill);
    final result = await _tradesmanRepo.getTradesman(
      skill: normalizedSkill,
      search: search,
      area: area,
      sort: sort,
      page: page,
      limit: limit,
    );

    return result.fold(
      (fail) async {
        setError(fail.message);
        d_print.log("Fetch tradesman failed: ${fail.message}");
        isTradesmanLoading.value = false;
        return allTradesman;
      },
      (success) async {
        final tradesmen = _mergeTradesmenForSkill(
          success.data.data,
          const [],
          normalizedSkill,
        );
        allTradesman.assignAll(tradesmen);
        d_print.log("Fetch tradesman success: $tradesmen");
        final mergedTradesmen = await _fetchExtraSkillFallback(
          skill: normalizedSkill,
          search: search,
          area: area,
          sort: sort,
          limit: limit,
        );
        isTradesmanLoading.value = false;
        return mergedTradesmen;
      },
    );
  }

  Future<List<Tradesman>> fetchTradesmenForCounts({int limit = 500}) async {
    final result = await _tradesmanRepo.getTradesman(
      skill: '',
      sort: 'rating',
      page: 1,
      limit: limit,
    );

    return result.fold((fail) {
      d_print.log("Fetch tradesman counts failed: ${fail.message}");
      return const <Tradesman>[];
    }, (success) => success.data.data);
  }

  Future<List<Tradesman>> _fetchExtraSkillFallback({
    required String skill,
    required String search,
    required String area,
    required String sort,
    required int limit,
  }) async {
    if (skill.trim().isEmpty) return allTradesman;

    final fallbackLimit = limit < 200 ? 200 : limit;
    final result = await _tradesmanRepo.getTradesman(
      skill: '',
      search: search,
      area: area,
      sort: sort,
      page: 1,
      limit: fallbackLimit,
    );

    result.fold(
      (fail) {
        d_print.log("Fetch extra skill fallback failed: ${fail.message}");
      },
      (success) {
        final mergedTradesmen = _mergeTradesmenForSkill(
          allTradesman.toList(),
          success.data.data,
          skill,
        );
        allTradesman.assignAll(mergedTradesmen);
      },
    );
    return allTradesman;
  }

  List<Tradesman> _mergeTradesmenForSkill(
    List<Tradesman> primary,
    List<Tradesman> fallback,
    String skill,
  ) {
    final merged = <Tradesman>[];
    final seen = <String>{};

    void addIfMatch(Tradesman tradesman) {
      if (!_tradesmanOffersSkill(tradesman, skill)) return;

      final key = tradesman.id.trim().isNotEmpty
          ? tradesman.id.trim()
          : '${tradesman.user.id}-${tradesman.mainSkill}-${tradesman.user.name}';
      if (seen.add(key)) {
        merged.add(tradesman);
      }
    }

    primary.forEach(addIfMatch);
    fallback.forEach(addIfMatch);
    return merged;
  }

  bool _tradesmanOffersSkill(Tradesman tradesman, String skill) {
    final target = _skillLookupKey(skill);
    if (target.isEmpty) return true;

    return [
      tradesman.mainSkill,
      ...tradesman.extraSkills,
    ].any((offeredSkill) => _skillLookupKey(offeredSkill) == target);
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
      final normalizedMainSkill = _normalizeSkillForApi(mainSkill);
      final normalizedExtraSkills = extraSkills
          .map(_normalizeSkillForApi)
          .where((skill) => skill.isNotEmpty)
          .toList();
      final formData = dio.FormData();
      formData.fields.addAll([
        MapEntry('pitch', pitch),
        MapEntry('rateAmount', normalizedAmount),
        MapEntry('rateUnit', normalizedRateUnit),
        MapEntry('mainSkill', normalizedMainSkill),
        MapEntry('extraSkills', jsonEncode(normalizedExtraSkills)),
        MapEntry('homeArea', homeArea),
        MapEntry('travelRange', normalizedTravelRange),
      ]);

      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        final imageFile = File(profileImagePath);
        if (await imageFile.exists()) {
          formData.files.add(
            MapEntry(
              'profileImage',
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

  Future<bool> updateRecentWorkPhotos({
    required String pitch,
    required String amount,
    required String unit,
    List<String> existingWorkPhotoUrls = const [],
    List<String> existingWorkPhotoPublicIds = const [],
    List<String> removedWorkPhotoUrls = const [],
    List<String> removedWorkPhotoPublicIds = const [],
    required List<String> workPhotoPaths,
  }) async {
    clearError();
    setLoading(true);

    try {
      final formData = dio.FormData();
      formData.fields.addAll([
        MapEntry('pitch', pitch),
        MapEntry('rateAmount', amount.trim()),
        MapEntry('rateUnit', _normalizeRateUnitForApi(unit)),
        MapEntry('existingWorkPhotos', jsonEncode(existingWorkPhotoUrls)),
        MapEntry('existingWorkPhotoUrls', jsonEncode(existingWorkPhotoUrls)),
        MapEntry(
          'existingWorkPhotoPublicIds',
          jsonEncode(existingWorkPhotoPublicIds),
        ),
        MapEntry('removedWorkPhotos', jsonEncode(removedWorkPhotoUrls)),
        MapEntry('removedWorkPhotoUrls', jsonEncode(removedWorkPhotoUrls)),
        MapEntry(
          'removedWorkPhotoPublicIds',
          jsonEncode(removedWorkPhotoPublicIds),
        ),
        MapEntry(
          'deleteWorkPhotoPublicIds',
          jsonEncode(removedWorkPhotoPublicIds),
        ),
        MapEntry('removedMissingWorkPhotos', 'true'),
      ]);

      for (final path in workPhotoPaths) {
        final imageFile = File(path);
        if (path.trim().isEmpty || !await imageFile.exists()) continue;

        formData.files.add(
          MapEntry(
            'workPhotos',
            await dio.MultipartFile.fromFile(imageFile.path),
          ),
        );
      }

      d_print.log(
        'Update recent work photos payload fields: ${formData.fields}, files: ${formData.files.map((file) => file.key).toList()}',
      );

      final result = await _tradesmanRepo.tellClient(formData);
      return result.fold(
        (fail) {
          setError(fail.message);
          d_print.log("Update recent work photos failed: ${fail.message}");
          return false;
        },
        (success) {
          d_print.log("Update recent work photos success: ${success.data}");
          return true;
        },
      );
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Update recent work photos error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> removeWorkPhoto({
    required String publicId,
    required String url,
    required String photoId,
  }) async {
    clearError();

    if (publicId.trim().isEmpty &&
        url.trim().isEmpty &&
        photoId.trim().isEmpty) {
      setError('Unable to remove this photo. Please try again.');
      return false;
    }

    final result = await _tradesmanRepo.removeWorkPhoto(
      publicId: publicId.trim(),
      url: url.trim(),
      photoId: photoId.trim(),
    );

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Remove work photo failed: ${fail.message}");
        return false;
      },
      (success) {
        d_print.log("Remove work photo success: ${success.message}");
        return true;
      },
    );
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

  String _normalizeSkillForApi(String skill) {
    switch (skill.trim().toLowerCase()) {
      case 'appliance fix':
        return 'Appliance';
      case 'fabricator/welder':
        return 'Welder/Gate';
      // case 'mechanic':
      //   return 'Mechanic';
      default:
        return skill.trim();
    }
  }

  String _skillLookupKey(String skill) {
    switch (_normalizeSkillForApi(skill).trim().toLowerCase()) {
      case 'appliance':
      case 'appliance fix':
        return 'appliance';
      // case 'mechanic':
      //   return 'Mechanic';
      case 'welder/gate':
      case 'fabricator/welder':
        return 'welder';
      default:
        return _normalizeSkillForApi(skill).trim().toLowerCase();
    }
  }

  Future<bool> addInquiry(
    String businessName,
    String whatsappPhone,
    List<String> tradesToAdvertiseTo,
  ) async {
    clearError();
    setLoading(true);

    final request = AddInquiryRequestModel(
      businessName: businessName,
      whatsappPhone: whatsappPhone,
      tradesToAdvertiseTo: tradesToAdvertiseTo,
    );

    final result = await _tradesmanRepo.addInquiry(request);

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Add inquiry failed: ${fail.message}");
        setLoading(false);
        return false;
      },
      (success) {
        d_print.log("Add inquiry success: ${success.data.toJson()}");
        setLoading(false);
        return true;
      },
    );
  }

  Future<List<Advertisement>> getAdvertise() async {
    clearError();
    isAdvertiseLoading.value = true;

    final result = await _tradesmanRepo.getAdvertise();

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log("Fetch advertise failed: ${fail.message}");
        isAdvertiseLoading.value = false;
        return advertisements;
      },
      (success) {
        advertisements.assignAll(
          success.data.data.where((advertise) => advertise.isActive),
        );
        d_print.log("Fetch advertise success: ${success.data.toJson()}");
        isAdvertiseLoading.value = false;
        return success.data.data;
      },
    );
  }

  Future<void> signOut() async {
    clearError();

    try {
      await _authStorageService.clearAuthData();
      dashboardData.value = null;

      if (Get.isRegistered<SessionService>()) {
        Get.find<SessionService>().clearToken();
      }

      Get.offAll(() => const SignInScreen());
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Sign out failed: $e');
    }
  }
}
