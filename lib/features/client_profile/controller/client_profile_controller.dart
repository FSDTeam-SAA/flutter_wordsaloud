import 'dart:developer' as d_print;
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_wordsaloud/core/base/base_controller.dart';
import 'package:flutter_wordsaloud/core/services/auth_storage_service.dart';
import 'package:flutter_wordsaloud/core/services/session_service.dart';
import 'package:flutter_wordsaloud/features/auth/controller/auth_controller.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_in_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_client_profile_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/update_profile_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/repositories/tradesman_repo.dart';
import 'package:get/get.dart';

class ClientProfileController extends BaseController {
  late final TradesmanRepo _tradesmanRepo = Get.find<TradesmanRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetClientProfileResponseModel> clientProfile =
      Rxn<GetClientProfileResponseModel>();
  final name = ''.obs;
  final phone = ''.obs;
  final area = ''.obs;
  final RxnString profileImagePath = RxnString();
  final RxnString profileImageUrl = RxnString();
  final memberSince = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClientProfile();
  }

  Future<GetClientProfileResponseModel?> fetchClientProfile() async {
    clearError();
    setLoading(true);

    final result = await _tradesmanRepo.getClientProfile();

    return result.fold(
      (fail) {
        setError(fail.message);
        d_print.log('Fetch client profile failed: ${fail.message}');
        setLoading(false);
        return null;
      },
      (success) {
        final profile = success.data;
        clientProfile.value = profile;
        _applyProfile(profile);
        d_print.log('Fetch client profile success: ${profile.toJson()}');
        setLoading(false);
        return profile;
      },
    );
  }

  Future<bool> ensureRequiredProfileInfoLoaded() async {
    if (clientProfile.value == null) {
      await fetchClientProfile();
    }

    return hasRequiredProfileInfo;
  }

  bool get hasRequiredProfileInfo {
    final profile = clientProfile.value;
    final hasName =
        _displayNameFromParts(
          name: profile?.name,
          firstName: profile?.firstName,
          lastName: profile?.lastName,
        ).isNotEmpty ||
        name.value.trim().isNotEmpty;
    final hasPhone =
        (profile?.phoneNumber?.trim().isNotEmpty ?? false) ||
        phone.value.trim().isNotEmpty;
    final hasArea =
        (profile?.area?.trim().isNotEmpty ?? false) ||
        area.value.trim().isNotEmpty;

    return hasName && hasPhone && hasArea;
  }

  void updateProfile({
    required String name,
    required String phone,
    required String area,
    String? profileImagePath,
  }) {
    this.name.value = name;
    _syncAuthUserName(name);
    this.phone.value = phone;
    this.area.value = area;
    this.profileImagePath.value = profileImagePath;
  }

  Future<bool> updateClientProfile({
    required String name,
    required String phone,
    required String area,
    String? profileImagePath,
  }) async {
    clearError();
    setLoading(true);

    try {
      final formData = dio.FormData();
      formData.fields.addAll([
        MapEntry('name', name.trim()),
        MapEntry('phoneNumber', phone.trim()),
        MapEntry('area', area.trim()),
      ]);

      final imagePath = profileImagePath?.trim() ?? '';
      if (imagePath.isNotEmpty) {
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          formData.files.add(
            MapEntry(
              'profileImage',
              await dio.MultipartFile.fromFile(imageFile.path),
            ),
          );
        }
      }

      final result = await _tradesmanRepo.updateClientProfile(formData);

      return result.fold(
        (fail) {
          setError(fail.message);
          d_print.log('Update client profile failed: ${fail.message}');
          return false;
        },
        (success) {
          _applyUpdatedProfile(success.data);
          this.profileImagePath.value = imagePath.isNotEmpty ? imagePath : null;
          d_print.log(
            'Update client profile success: ${success.data.toJson()}',
          );
          return true;
        },
      );
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Update client profile error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    clearError();

    try {
      await _authStorageService.clearAuthData();
      clientProfile.value = null;

      if (Get.isRegistered<SessionService>()) {
        Get.find<SessionService>().clearToken();
      }

      Get.offAll(() => const SignInScreen());
    } catch (e) {
      setError('Something went wrong. Please try again.');
      d_print.log('Sign out failed: $e');
    }
  }

  void _applyProfile(GetClientProfileResponseModel profile) {
    final displayName = _displayName(profile);
    if (displayName.isNotEmpty) {
      name.value = displayName;
      _syncAuthUserName(displayName);
    }

    final phoneNumber = profile.phoneNumber?.trim() ?? '';
    if (phoneNumber.isNotEmpty) phone.value = phoneNumber;

    final profileArea = profile.area?.trim() ?? '';
    if (profileArea.isNotEmpty) area.value = profileArea;

    final imageUrl = profile.profileImage?.url?.trim() ?? '';
    profileImageUrl.value = imageUrl.isNotEmpty ? imageUrl : null;

    final createdAt = profile.createdAt?.trim() ?? '';
    memberSince.value = _formatMemberSince(createdAt);
  }

  void _applyUpdatedProfile(UpdateProfileResponseModel profile) {
    final displayName = _displayNameFromParts(
      name: profile.name,
      firstName: profile.firstName,
      lastName: profile.lastName,
    );
    if (displayName.isNotEmpty) {
      name.value = displayName;
      _syncAuthUserName(displayName);
    }

    final phoneNumber = profile.phoneNumber?.trim() ?? '';
    if (phoneNumber.isNotEmpty) phone.value = phoneNumber;

    final profileArea = profile.area?.trim() ?? '';
    if (profileArea.isNotEmpty) area.value = profileArea;

    final imageUrl = profile.profileImage?.url?.trim() ?? '';
    profileImageUrl.value = imageUrl.isNotEmpty ? imageUrl : null;

    final createdAt = profile.createdAt?.trim() ?? '';
    if (createdAt.isNotEmpty) {
      memberSince.value = _formatMemberSince(createdAt);
    }
  }

  String _displayName(GetClientProfileResponseModel profile) {
    return _displayNameFromParts(
      name: profile.name,
      firstName: profile.firstName,
      lastName: profile.lastName,
    );
  }

  String _displayNameFromParts({
    String? name,
    String? firstName,
    String? lastName,
  }) {
    final explicitName = name?.trim() ?? '';
    if (explicitName.isNotEmpty) return explicitName;

    return [
      firstName?.trim() ?? '',
      lastName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }

  String _formatMemberSince(String value) {
    final createdAt = DateTime.tryParse(value);
    if (createdAt == null) return '';

    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return 'MEMBER SINCE ${months[createdAt.month - 1]} ${createdAt.year}';
  }

  String get initial {
    final trimmedName = name.value.trim();
    if (trimmedName.isEmpty) return 'U';
    return trimmedName.substring(0, 1).toUpperCase();
  }

  void _syncAuthUserName(String value) {
    final trimmedName = value.trim();
    if (trimmedName.isEmpty || !Get.isRegistered<AuthController>()) return;

    Get.find<AuthController>().currentUserName.value = trimmedName;
  }
}
