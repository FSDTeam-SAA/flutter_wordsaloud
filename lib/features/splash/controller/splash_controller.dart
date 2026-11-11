import 'package:flutter/widgets.dart';
import 'package:aturservicett/features/home/controller/home_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/dashboard_response_model.dart';
import 'package:aturservicett/core/services/auth_storage_service.dart';
import 'package:aturservicett/core/services/tradesman_profile_status_service.dart';
import 'package:get/get.dart';
import 'package:aturservicett/features/auth/screens/role_selection_screen.dart';
import 'package:aturservicett/features/home/screens/home_screen.dart';
import 'package:aturservicett/features/tradesman_account_creation/screens/tradesman_dashboard.dart';
import 'package:aturservicett/features/tradesman_account_creation/screens/what_do_screen.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final AuthStorageService _authStorageService = AuthStorageService();
  final TradesmanProfileStatusService _tradesmanProfileStatusService =
      TradesmanProfileStatusService();

  late AnimationController logoController;
  late AnimationController textRevealController;
  late Animation<double> logoFadeAnimation;
  late Animation<double> textRevealAnimation;

  final RxBool showSubtext = false.obs;
  late final Future<Widget> _initialScreen;

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

    // Prepare the destination while the splash animates, before showing its UI.
    _initialScreen = _prepareInitialScreen();
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

    // Keep the splash visible until both the animation and initial data are ready.
    await Future.delayed(const Duration(milliseconds: 1300));
    final screen = await _initialScreen;
    if (isClosed) return;
    Get.offAll(() => screen);
  }

  Future<Widget> _prepareInitialScreen() async {
    final isAuthenticated = await _authStorageService.isAuthenticated();
    if (!isAuthenticated) {
      return const RoleSelectionScreen();
    }

    final role = (await _authStorageService.getRole())?.toLowerCase().trim();
    if (role == 'tradesman') {
      TradesmanDashboardResponse? dashboard;
      final isProfileCompleted = await _tradesmanProfileStatusService
          .hasCompletedProfile(onDashboardLoaded: (data) => dashboard = data);

      return isProfileCompleted
          ? TradesmanDashboard(initialDashboard: dashboard)
          : const WhatDoScreen();
    }

    // Pass values rather than registering a controller owned by the splash route.
    final home = HomeController();
    await home.fetchSkillList();
    return HomeScreen(initialCategories: home.categories.toList());
  }

  @override
  void onClose() {
    logoController.dispose();
    textRevealController.dispose();
    super.onClose();
  }
}
