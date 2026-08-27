import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/core/common/widgets/press_back_to_exit.dart';
import 'package:flutter_wordsaloud/features/auth/controller/auth_controller.dart';
import 'package:flutter_wordsaloud/features/client_profile/controller/client_profile_controller.dart';
import 'package:flutter_wordsaloud/features/client_profile/screens/profile_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/features/home/controller/home_controller.dart';
import 'package:flutter_wordsaloud/features/home/screens/category_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool showCustomerModeBanner;

  const HomeScreen({super.key, this.showCustomerModeBanner = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController controller;
  late final ClientProfileController _clientProfileController;
  late final TextEditingController _searchTextController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchFocusNode = FocusNode();
    controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    _clientProfileController = Get.isRegistered<ClientProfileController>()
        ? Get.find<ClientProfileController>()
        : Get.put(ClientProfileController());
    controller.fetchSkillList();

    if (widget.showCustomerModeBanner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showCustomerModeNotification();
      });
    }
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchTextController.clear();
    controller.searchQuery.value = '';
    _searchFocusNode.unfocus();
  }

  void _showCustomerModeNotification() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.05,
              ),
              children: const [
                TextSpan(
                  text: "You're browsing as a ",
                  style: TextStyle(color: Color(0xFFF4C24F)),
                ),
                TextSpan(
                  text: 'customer',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1F1716),
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).size.height - 120,
          ),
        ),
      );
  }

  String _userInitial() {
    final profileInitial = _clientProfileController.initial;
    if (profileInitial != 'U') return profileInitial;

    if (Get.isRegistered<AuthController>()) {
      final name = Get.find<AuthController>().currentUserName.value.trim();
      if (name.isNotEmpty) return name[0].toUpperCase();
    }

    return 'U';
  }

  Future<void> _openCategory(TradeCategory category) async {
    final hasProfileInfo = await _clientProfileController
        .ensureRequiredProfileInfoLoaded();

    if (!hasProfileInfo) {
      Get.snackbar(
        'Complete your profile',
        'Add your name, phone number, and area first.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF221C18),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.person, color: Color(0xFFE8B04B)),
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
            Get.to(() => ProfileScreen());
          },
          child: Text(
            'Complete',
            style: GoogleFonts.outfit(
              color: const Color(0xFFE8B04B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
      return;
    }

    Get.to(() => CategoryDetailsScreen(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return PressBackToExit(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5EFE6),
        body: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              color: const Color(0xFFAE3F30),
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 52,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + Avatar row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.showCustomerModeBanner) ...[
                            IconButton(
                              onPressed: Get.back,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 32,
                                height: 32,
                              ),
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Logo circle
                          Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8B04B),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(
                                'assets/images/aturservicett-logo-full-512px 2.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // User initial avatar
                      GestureDetector(
                        onTap: () => Get.to(() => ProfileScreen()),
                        child: Obx(() {
                          final shouldHighlight =
                              !_clientProfileController.hasRequiredProfileInfo;

                          return Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: shouldHighlight
                                  ? const Color(0xFFFFD75E)
                                  : const Color(0xFFE8B04B),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: shouldHighlight
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: shouldHighlight
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x99FFE8A3),
                                        blurRadius: 18,
                                        spreadRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ClipOval(
                              child: _HomeProfileAvatar(
                                imagePath: _clientProfileController
                                    .profileImagePath
                                    .value,
                                imageUrl: _clientProfileController
                                    .profileImageUrl
                                    .value,
                                initial: _userInitial(),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.25,
                      ),
                      children: const [
                        TextSpan(text: 'Find a good\n'),
                        TextSpan(
                          text: 'tradesman ',
                          style: TextStyle(color: Color(0xFFEAAE4B)),
                        ),
                        TextSpan(text: 'today.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Obx(
                      () => TextField(
                        controller: _searchTextController,
                        focusNode: _searchFocusNode,
                        onChanged: (v) => controller.searchQuery.value = v,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search ...',
                          hintStyle: GoogleFonts.outfit(
                            color: const Color(0xFF9E9E9E),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF9E9E9E),
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 4,
                          ),
                          suffixIcon: controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color(0xFF9E9E9E),
                                    size: 18,
                                  ),
                                  onPressed: _clearSearch,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Categories Grid ─────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                final items = controller.filteredCategories;
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No matches found.',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: const Color(0xFF6D6D6D),
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Browse Trades',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${controller.categories.length} Categories',
                            style: TextStyle(
                              color: Color(0xFFA83F2D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        // padding: EdgeInsets.zero,
                        padding: const EdgeInsets.only(
                          left: 18,
                          top: 10,
                          bottom: 18,
                          right: 18,
                        ),
                        itemCount: items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 7,
                            ),
                        itemBuilder: (context, index) {
                          final cat = items[index];
                          final bool hasRedBorder = index == 0;
                          final bool hasTealBorder = cat.isNew && index != 0;

                          Color borderColor = const Color(0xFFF3E5CF);

                          if (hasRedBorder) {
                            borderColor = const Color(0xFFA83F2D);
                          }
                          if (hasTealBorder) {
                            borderColor = const Color(0xFF22707F);
                          }

                          // Subtitle color matches the border (teal for new/teal cards, red-brown for others)
                          final Color subLabelColor = hasTealBorder
                              ? const Color(0xFF22707F)
                              : const Color(0xFFA83F2D);

                          // Colors for the circular background of icons (matching mockup diversity)
                          final List<Color> circleColors = [
                            const Color(0xFFFDE8E8), // light red/pink
                            const Color(0xFFE3F2FD), // light blue
                            const Color(0xFFFFF9C4), // light yellow
                            const Color(0xFFE8F5E9), // light green
                            const Color(0xFFFCE4EC), // light pink
                            const Color(0xFFFFE0B2), // light orange
                          ];
                          final Color iconBgColor =
                              circleColors[index % circleColors.length];

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () => _openCategory(cat),
                                child: SizedBox.expand(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      left: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Icon rounded container
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: iconBgColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              cat.image,
                                              width: 18,
                                              height: 18,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Name
                                        Text(
                                          cat.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            height: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        // Listed count
                                        Text(
                                          '${cat.listed} Listed',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: subLabelColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // "New" badge (shifted to top-left overlapping top border)
                              if (cat.isNew)
                                Positioned(
                                  top: -10,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: index == 0
                                            ? const Color(0xFFA83F2D)
                                            : const Color(0xFF22707F),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      'New',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: index == 0
                                            ? const Color(0xFFA83F2D)
                                            : const Color(0xFF22707F),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeProfileAvatar extends StatelessWidget {
  const _HomeProfileAvatar({
    required this.imagePath,
    required this.imageUrl,
    required this.initial,
  });

  final String? imagePath;
  final String? imageUrl;
  final String initial;

  @override
  Widget build(BuildContext context) {
    final selectedImagePath = imagePath?.trim() ?? '';
    if (selectedImagePath.isNotEmpty) {
      return Image.file(
        File(selectedImagePath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    final uploadedImageUrl = imageUrl?.trim() ?? '';
    if (uploadedImageUrl.isNotEmpty) {
      return Image.network(
        uploadedImageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _HomeInitialAvatar(initial: initial),
      );
    }

    return _HomeInitialAvatar(initial: initial);
  }
}

class _HomeInitialAvatar extends StatelessWidget {
  const _HomeInitialAvatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Text(
        initial,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
