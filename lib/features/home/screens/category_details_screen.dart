import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/core/common/widgets/app_network_image.dart';
import 'package:flutter_wordsaloud/core/common/widgets/app_network_video.dart';
import 'package:flutter_wordsaloud/features/auth/controller/auth_controller.dart';
import 'package:flutter_wordsaloud/features/client_profile/controller/client_profile_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/features/home/controller/home_controller.dart';
import 'package:flutter_wordsaloud/features/client_profile/screens/advertise_inquiry_screen.dart';
import 'package:flutter_wordsaloud/features/home/screens/tradesman_details_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_all_tradesman_response_model.dart'
    as tradesman_model;

import '../../client_profile/screens/profile_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final TradeCategory category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  late final TradesmanController _tradesmanController;
  late final ClientProfileController _clientProfileController;
  String _selectedSort = 'rating';

  @override
  void initState() {
    super.initState();
    _tradesmanController = Get.find<TradesmanController>();
    _clientProfileController = Get.isRegistered<ClientProfileController>()
        ? Get.find<ClientProfileController>()
        : Get.put(ClientProfileController());
    _tradesmanController.fetchTradesman(
      skill: widget.category.name,
      sort: _selectedSort,
    );
    _tradesmanController.getAdvertise();
  }

  Future<void> _changeSort(String? sort) async {
    if (sort == null || sort == _selectedSort) return;

    setState(() => _selectedSort = sort);
    await _tradesmanController.fetchTradesman(
      skill: widget.category.name,
      sort: sort,
    );
  }

  List<tradesman_model.Tradesman> _sortedTradesmen(
    List<tradesman_model.Tradesman> tradesmen,
  ) {
    final sortedTradesmen = tradesmen.toList();
    if (_selectedSort == 'recent') {
      sortedTradesmen.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } else {
      sortedTradesmen.sort(
        (a, b) => b.ratingAverage.compareTo(a.ratingAverage),
      );
    }
    return sortedTradesmen;
  }

  String get _selectedSortLabel =>
      _selectedSort == 'recent' ? 'Recently Active' : 'Highest Rated';

  String _userInitial() {
    final profileInitial = _clientProfileController.initial;
    if (profileInitial != 'U') return profileInitial;

    if (Get.isRegistered<AuthController>()) {
      final name = Get.find<AuthController>().currentUserName.value.trim();
      if (name.isNotEmpty) return name[0].toUpperCase();
    }

    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    // Format the title (e.g. Plumber -> Plumbers)
    final String displayTitle = widget.category.name.endsWith('s')
        ? widget.category.name
        : (widget.category.name == 'Welder/Gate'
              ? 'Welder/Gates'
              : '${widget.category.name}s');

    return Scaffold(
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
                // Back Button + User Avatar row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Get.back(),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // User initial avatar
                    InkWell(
                      onTap: () => Get.to(() => ProfileScreen()),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8B04B),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Obx(
                            () => _CategoryProfileAvatar(
                              imagePath: _clientProfileController
                                  .profileImagePath
                                  .value,
                              imageUrl: _clientProfileController
                                  .profileImageUrl
                                  .value,
                              initial: _userInitial(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Category Title
                Text(
                  displayTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable Body ─────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final tradesmen = _sortedTradesmen(
                _tradesmanController.allTradesman.toList(),
              );
              final vipTradesmen = tradesmen
                  .where((tradesman) => tradesman.isVip)
                  .toList();
              final isLoading = _tradesmanController.isTradesmanLoading.value;

              if (isLoading && tradesmen.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFA83F2D)),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        top: 20,
                        right: 18,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${tradesmen.length} ${widget.category.name.toLowerCase()}s Near You',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ),
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE5D8CD),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedSort,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: Color(0xFF1F1F1F),
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F1F1F),
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: _changeSort,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'rating',
                                    child: Text('Highest Rated'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'recent',
                                    child: Text('Recently Active'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      color: Color(0xFFFFF8F2),
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    const SizedBox(height: 16),
                    if (vipTradesmen.isNotEmpty) ...[
                      _buildVipHeader(),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          itemCount: vipTradesmen.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return _buildVipCardFromTradesman(
                              vipTradesmen[index],
                              hasGoldBorder: index == 0,
                            );
                          },
                        ),
                      ),
                      _buildVipDots(vipTradesmen.length),
                      const SizedBox(height: 16),
                      const Divider(
                        color: Color(0xFFFFF8F2),
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      const SizedBox(height: 24),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'All ${widget.category.name} sorted by $_selectedSortLabel',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (tradesmen.isEmpty)
                      _buildEmptyState()
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            for (
                              int index = 0;
                              index < tradesmen.length;
                              index++
                            ) ...[
                              _buildVerticalCardFromTradesman(
                                tradesmen[index],
                                isTopRated: index == 0,
                              ),
                              const SizedBox(height: 12),
                              if (index == 1) ...[
                                _buildSponsoredSlotCard(),
                                const SizedBox(height: 12),
                              ],
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Helper UI Builders ──────────────────────────────────────────────────────

  Widget _buildVipHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFEAAE4B), size: 18),
              SizedBox(width: 4),
              Text(
                'VIP Featured',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFAE3F30),
                ),
              ),
            ],
          ),
          const Text(
            'SPONSORED',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFFA83F2D),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipDots(int count) {
    final visibleCount = count.clamp(1, 3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(visibleCount, (index) {
        final isActive = index == 0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFA83F2D) : const Color(0xFFEAAE4B),
            borderRadius: isActive ? BorderRadius.circular(3) : null,
            shape: isActive ? BoxShape.rectangle : BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3E5CF), width: 1.5),
        ),
        child: const Text(
          'No tradesmen found for this category yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6D6D6D),
          ),
        ),
      ),
    );
  }

  Widget _buildVipCardFromTradesman(
    tradesman_model.Tradesman tradesman, {
    required bool hasGoldBorder,
  }) {
    return _buildVipCard(
      name: _displayName(tradesman),
      location: _displayLocation(tradesman),
      avatarLetter: _initials(_displayName(tradesman)),
      profileImageUrl: tradesman.user.profileImage.url,
      hasVipBadge: true,
      hasGoldBorder: hasGoldBorder,
      tradesman: tradesman,
    );
  }

  Widget _buildVerticalCardFromTradesman(
    tradesman_model.Tradesman tradesman, {
    required bool isTopRated,
  }) {
    return _buildVerticalCard(
      name: _displayName(tradesman),
      location: _displayLocation(tradesman),
      avatarLetter: _initials(_displayName(tradesman)),
      profileImageUrl: tradesman.user.profileImage.url,
      rating: _ratingLabel(tradesman),
      price: tradesman.typicalRate.amount.toString(),
      priceUnit: _rateUnitLabel(tradesman.typicalRate.unit),
      isTopRated: isTopRated,
      tradesman: tradesman,
    );
  }

  void _openTradesmanDetails(
    tradesman_model.Tradesman tradesman, {
    required String name,
    required String location,
    required String avatarLetter,
    required String rating,
  }) {
    Get.to(
      () => TradesmanDetailsScreen(
        tradesmanId: tradesman.id,
        name: name,
        location: location,
        avatarLetter: avatarLetter,
        rating: rating.split('-').first,
        categoryName: widget.category.name,
        pitch: tradesman.pitch,
        extraTrades: tradesman.extraSkills,
        rate: tradesman.typicalRate.amount > 0
            ? tradesman.typicalRate.amount.toString()
            : '',
        rateUnit: _rateUnitLabel(tradesman.typicalRate.unit),
      ),
    );
  }

  String _displayName(tradesman_model.Tradesman tradesman) {
    final user = tradesman.user;
    final fullName = user.name.trim().isNotEmpty
        ? user.name.trim()
        : [
            user.firstName,
            user.lastName,
          ].where((part) => part.trim().isNotEmpty).join(' ');

    if (fullName.trim().isEmpty) return 'Tradesman';

    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }

  String _displayLocation(tradesman_model.Tradesman tradesman) {
    final area = tradesman.homeArea.trim().isNotEmpty
        ? tradesman.homeArea.trim()
        : tradesman.user.area.trim();
    return area.isNotEmpty ? area : 'Trinidad';
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'T';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _ratingLabel(tradesman_model.Tradesman tradesman) {
    final rating = tradesman.ratingAverage <= 0
        ? 'New'
        : tradesman.ratingAverage % 1 == 0
        ? tradesman.ratingAverage.toInt().toString()
        : tradesman.ratingAverage.toStringAsFixed(1);
    final reviewLabel = tradesman.ratingCount == 1 ? 'review' : 'reviews';
    return '$rating  ${tradesman.ratingCount} $reviewLabel';
  }

  String _rateUnitLabel(String unit) {
    final normalized = unit.trim().toLowerCase();
    if (normalized.contains('hour')) return 'hour';
    if (normalized.contains('job')) return 'job';
    return 'day';
  }

  Widget _buildVipCard({
    required String name,
    required String location,
    required String avatarLetter,
    String? profileImageUrl,
    required bool hasVipBadge,
    required bool hasGoldBorder,
    tradesman_model.Tradesman? tradesman,
  }) {
    return GestureDetector(
      onTap: () {
        if (tradesman != null) {
          _openTradesmanDetails(
            tradesman,
            name: name,
            location: location,
            avatarLetter: avatarLetter,
            rating: _ratingLabel(tradesman),
          );
          return;
        }

        Get.to(
          () => TradesmanDetailsScreen(
            name: name,
            location: location,
            avatarLetter: avatarLetter,
            rating: '4.9',
            categoryName: widget.category.name,
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasGoldBorder
                    ? const Color(0xFFEAAE4B)
                    : const Color(0xFFF3E5CF),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.only(
              top: 18,
              left: 12,
              right: 12,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with gradient
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFD85C27), Color(0xFFF5B54C)],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _TradesmanCardAvatar(
                      imageUrl: profileImageUrl,
                      avatarLetter: avatarLetter,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 2),
                // Location
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
              ],
            ),
          ),
          if (hasVipBadge)
            Positioned(
              top: -9,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEAAE4B), width: 1),
                ),
                child: const Text(
                  'VIP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFEAAE4B),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerticalCard({
    required String name,
    required String location,
    required String avatarLetter,
    String? profileImageUrl,
    required String rating,
    required String price,
    required String priceUnit,
    required bool isTopRated,
    tradesman_model.Tradesman? tradesman,
  }) {
    return GestureDetector(
      onTap: () {
        if (tradesman != null) {
          _openTradesmanDetails(
            tradesman,
            name: name,
            location: location,
            avatarLetter: avatarLetter,
            rating: rating,
          );
          return;
        }

        Get.to(
          () => TradesmanDetailsScreen(
            name: name,
            location: location,
            avatarLetter: avatarLetter,
            rating: rating.split('-').first,
            categoryName: widget.category.name,
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isTopRated
                    ? const Color(0xFFAE3F30)
                    : const Color(0xFFF3E5CF),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: isTopRated
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFAE3F30), Color(0xFFFEBD5B)],
                          )
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF30AE5A), Color(0xFF355E69)],
                          ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _TradesmanCardAvatar(
                      imageUrl: profileImageUrl,
                      avatarLetter: avatarLetter,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6C6C6C),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFEAAE4B),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF004B62),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFAE3F30),
                      ),
                    ),
                    Text(
                      priceUnit,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C6C6C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isTopRated)
            Positioned(
              top: -9,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFAE3F30), width: 1),
                ),
                child: const Text(
                  'Top Rated',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFAE3F30),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSponsoredSlotCard() {
    return Obx(() {
      final isLoading = _tradesmanController.isAdvertiseLoading.value;
      final advertisement = _tradesmanController.advertisements.isNotEmpty
          ? _tradesmanController.advertisements.first
          : null;

      return DashedBorderContainer(
        color: const Color(0xFFC7B9A4),
        borderRadius: 12,
        strokeWidth: 1.5,
        gap: 5,
        dashLength: 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CustomPaint(
              painter: _SponsoredStripePainter(),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFAE3F30),
                        ),
                      )
                    : advertisement == null
                    ? _buildAvailableSponsoredSlotContent()
                    : _buildAdvertisementContent(
                        title: advertisement.title,
                        description: advertisement.description,
                        mediaUrl: advertisement.mediaUrl,
                        mediaType: advertisement.mediaType,
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAdvertisementContent({
    required String title,
    required String description,
    required String mediaUrl,
    required String mediaType,
  }) {
    final hasMedia = mediaUrl.trim().isNotEmpty;

    if (hasMedia) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildAdvertisementMedia(mediaUrl: mediaUrl, mediaType: mediaType),
          Positioned(
            top: 8,
            left: 8,
            child: _SponsoredBadge(
              label: 'SPONSORED',
              backgroundColor: Colors.black.withValues(alpha: 0.62),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'SPONSORED',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: Color(0xFF8C7F72),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6B5),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(Icons.campaign, color: Color(0xFFAE3F30), size: 20),
        ),
        const SizedBox(height: 7),
        Text(
          title.trim().isNotEmpty ? title.trim() : 'Sponsored partner',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F0F0F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description.trim().isNotEmpty
              ? description.trim()
              : 'Serving customers looking for ${widget.category.name.toLowerCase()} help.',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvertisementMedia({
    required String mediaUrl,
    required String mediaType,
  }) {
    if (mediaType == 'video') {
      return AppNetworkVideo(
        videoUrl: mediaUrl,
        autoPlay: true,
        muted: true,
        looping: true,
        fit: BoxFit.contain,
      );
    }

    return AppNetworkImage(
      imageUrl: mediaUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      placeholder: const ColoredBox(
        color: Color(0xFFE9DFD3),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFAE3F30),
            ),
          ),
        ),
      ),
      errorWidget: const ColoredBox(
        color: Color(0xFFE9DFD3),
        child: Center(
          child: Icon(Icons.broken_image_outlined, color: Color(0xFF8C7F72)),
        ),
      ),
    );
  }

  Widget _buildAvailableSponsoredSlotContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'SPONSORED SLOT - AVAILABLE',
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8C7F72),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF1E7DC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text('📦', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 7),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F0F0F),
            ),
            children: [
              TextSpan(text: 'Your store could be '),
              TextSpan(
                text: 'here.',
                style: TextStyle(
                  color: Color(0xFFAE3F30),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Reach Trinis searching ${widget.category.name.toLowerCase()} right now.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => Get.to(() => const AdvertiseInquiryScreen()),
            borderRadius: BorderRadius.circular(18),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                'Inquire about advertising →',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SponsoredBadge extends StatelessWidget {
  const _SponsoredBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: foregroundColor,
            letterSpacing: 1.2,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _TradesmanCardAvatar extends StatelessWidget {
  const _TradesmanCardAvatar({
    required this.imageUrl,
    required this.avatarLetter,
    required this.fontSize,
  });

  final String? imageUrl;
  final String avatarLetter;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final uploadedImageUrl = imageUrl?.trim() ?? '';
    if (uploadedImageUrl.isNotEmpty) {
      return Image.network(
        uploadedImageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _TradesmanInitialAvatar(
          avatarLetter: avatarLetter,
          fontSize: fontSize,
        ),
      );
    }

    return _TradesmanInitialAvatar(
      avatarLetter: avatarLetter,
      fontSize: fontSize,
    );
  }
}

class _TradesmanInitialAvatar extends StatelessWidget {
  const _TradesmanInitialAvatar({
    required this.avatarLetter,
    required this.fontSize,
  });

  final String avatarLetter;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        avatarLetter,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _CategoryProfileAvatar extends StatelessWidget {
  const _CategoryProfileAvatar({
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
        width: 44,
        height: 44,
        fit: BoxFit.cover,
      );
    }

    final uploadedImageUrl = imageUrl?.trim() ?? '';
    if (uploadedImageUrl.isNotEmpty) {
      return Image.network(
        uploadedImageUrl,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _CategoryInitialAvatar(initial: initial),
      );
    }

    return _CategoryInitialAvatar(initial: initial);
  }
}

class _CategoryInitialAvatar extends StatelessWidget {
  const _CategoryInitialAvatar({required this.initial});

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

class _SponsoredStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF7EEE7)
      ..strokeWidth = 1;

    for (double x = -size.height; x < size.width + size.height; x += 14) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SponsoredStripePainter oldDelegate) => false;
}

// ── Dashed Border Container Widgets ───────────────────────────────────────────

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.color = const Color(0xFFEAAE4B),
    this.strokeWidth = 1.5,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedRectPainter(
        color: color,
        strokeWidth: strokeWidth,
        gap: gap,
        dashLength: dashLength,
        borderRadius: borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashLength : gap;
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
