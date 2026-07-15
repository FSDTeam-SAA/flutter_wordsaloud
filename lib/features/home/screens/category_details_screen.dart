import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_wordsaloud/features/auth/controller/signup_controller.dart';
import 'package:flutter_wordsaloud/features/home/controller/home_controller.dart';
import 'package:flutter_wordsaloud/features/client_profile/screens/advertise_inquiry_screen.dart';
import 'package:flutter_wordsaloud/features/home/screens/tradesman_details_screen.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final TradeCategory category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Get the signed-in user's first name initial for the header avatar
    String userInitial = 'K';
    if (Get.isRegistered<SignupController>()) {
      final name = Get.find<SignupController>().firstName.value.trim();
      if (name.isNotEmpty) userInitial = name[0].toUpperCase();
    }

    // Format the title (e.g. Plumber -> Plumbers)
    final String displayTitle = category.name.endsWith('s')
        ? category.name
        : (category.name == 'Welder/Gate'
              ? 'Welder/Gates'
              : '${category.name}s');

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
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8B04B),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userInitial,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 12 plumber Near You
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      top: 20,
                      right: 18,
                    ),
                    child: Text(
                      '12 ${category.name.toLowerCase()} Near You',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFFFF8F2),
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  const SizedBox(height: 16),

                  // VIP Featured Row Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFEAAE4B),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'VIP Featured',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFAE3F30),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'SPONSORED',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFA83F2D),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // VIP Grid/Horizontal List
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      children: [
                        // Card 1: VIP Active
                        _buildVipCard(
                          name: 'Rishi L.',
                          location: 'Tunapuna 7.km',
                          avatarLetter: 'R',
                          hasVipBadge: true,
                          hasGoldBorder: true,
                        ),
                        const SizedBox(width: 12),
                        // Card 2: Regular VIP
                        _buildVipCard(
                          name: 'Rishi L.',
                          location: 'Tunapuna 7.km',
                          avatarLetter: 'R',
                          hasVipBadge: false,
                          hasGoldBorder: false,
                        ),
                        const SizedBox(width: 12),
                        // Card 3: Regular VIP
                        _buildVipCard(
                          name: 'Rishi L.',
                          location: 'Tunapuna 7.km',
                          avatarLetter: 'R',
                          hasVipBadge: false,
                          hasGoldBorder: false,
                        ),
                      ],
                    ),
                  ),

                  // Indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA83F2D),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAAE4B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAAE4B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFFFF8F2),
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  const SizedBox(height: 24),

                  // All Plumber sorted by Rating Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'All ${category.name} sorted by Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vertical Lists of Plumbers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        // Card 1: Top Rated
                        _buildVerticalCard(
                          name: 'Rishi L.',
                          location: 'Tunapuna 7.km',
                          avatarLetter: 'T',
                          rating: '4.9-56 reviews',
                          price: '325',
                          priceUnit: 'day',
                          isTopRated: true,
                        ),
                        const SizedBox(height: 12),

                        // Card 2: Normal Rated
                        _buildVerticalCard(
                          name: 'Rishi L.',
                          location: 'Tunapuna 7.km',
                          avatarLetter: 'T',
                          rating: '4.9-56 reviews',
                          price: '325',
                          priceUnit: 'day',
                          isTopRated: false,
                        ),
                        const SizedBox(height: 12),

                        // Card 3: Sponsored slot
                        _buildSponsoredSlotCard(),
                        const SizedBox(height: 12),

                        // Card 4: Normal Rated
                        _buildVerticalCard(
                          name: 'Rishi L.',
                          location: 'Tunapuna 7.km',
                          avatarLetter: 'T',
                          rating: '4.9-56 reviews',
                          price: '325',
                          priceUnit: 'day',
                          isTopRated: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper UI Builders ──────────────────────────────────────────────────────

  Widget _buildVipCard({
    required String name,
    required String location,
    required String avatarLetter,
    required bool hasVipBadge,
    required bool hasGoldBorder,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => TradesmanDetailsScreen(
            name: name,
            location: location,
            avatarLetter: avatarLetter,
            rating: '4.9',
            categoryName: category.name,
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
                  child: Center(
                    child: Text(
                      avatarLetter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
    required String rating,
    required String price,
    required String priceUnit,
    required bool isTopRated,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => TradesmanDetailsScreen(
            name: name,
            location: location,
            avatarLetter: avatarLetter,
            rating: rating.split('-').first,
            categoryName: category.name,
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
                  child: Center(
                    child: Text(
                      avatarLetter,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
    return DashedBorderContainer(
      color: const Color(0xFFC7B9A4),
      borderRadius: 12,
      strokeWidth: 1.5,
      gap: 5,
      dashLength: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: _SponsoredStripePainter(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            child: Center(
              child: Column(
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
                  const Text(
                    'Reach Trinis searching plumbers right now.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
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
              ),
            ),
          ),
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
