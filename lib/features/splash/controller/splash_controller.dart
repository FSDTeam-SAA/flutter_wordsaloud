import 'package:flutter/animation.dart';
import 'package:flutter_wordsaloud/core/services/auth_storage_service.dart';
import 'package:flutter_wordsaloud/core/services/tradesman_profile_status_service.dart';
import 'package:get/get.dart';
import 'package:flutter_wordsaloud/features/auth/screens/role_selection_screen.dart';
import 'package:flutter_wordsaloud/features/home/screens/home_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tradesman_dashboard.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/what_do_screen.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final AuthStorageService _authStorageService = AuthStorageService();
  final TradesmanProfileStatusService _tradesmanProfileStatusService =
      TradesmanProfileStatusService();

  late AnimationController logoController;
  late AnimationController textRevealController;
  late Animation<double> logoFadeAnimation;
  late Animation<double> textRevealAnimation;

  final RxBool showSubtext = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Logo Fade Animation
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    logoFadeAnimation = CurvedAnimation(
      parent: logoController,
      curve: Curves.easeIn,
    );

    // Text Reveal Animation (logotext image)
    textRevealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: textRevealController,
        curve: Curves.easeInOutQuart,
      ),
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // 1. Fade in the logo (faster)
    await logoController.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    // 2. Reveal the logotext image (faster)
    await textRevealController.forward();

    // 3. Show the subtext
    showSubtext.value = true;

    // 4. Navigate to Role Selection Screen after remaining time to hit exactly 3 seconds total
    await Future.delayed(const Duration(milliseconds: 1300));
    await _navigateToInitialScreen();
  }

  Future<void> _navigateToInitialScreen() async {
    final isAuthenticated = await _authStorageService.isAuthenticated();
    if (!isAuthenticated) {
      Get.offAll(() => const RoleSelectionScreen());
      return;
    }

    final role = (await _authStorageService.getRole())?.toLowerCase().trim();
    if (role == 'tradesman') {
      final isProfileCompleted = await _tradesmanProfileStatusService
          .hasCompletedProfile();

      Get.offAll(
        () => isProfileCompleted
            ? const TradesmanDashboard(tradesmanName: 'Tradesman')
            : const WhatDoScreen(),
      );
      return;
    }

    Get.offAll(() => const HomeScreen());
  }

  @override
  void onClose() {
    logoController.dispose();
    textRevealController.dispose();
    super.onClose();
  }
}
