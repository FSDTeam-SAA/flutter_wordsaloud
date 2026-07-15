import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tradesman_edit_profile_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tradesman_publicview_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/features/home/screens/tradesman_details_screen.dart';
import 'package:flutter_wordsaloud/features/home/screens/home_screen.dart';
import 'package:flutter_wordsaloud/features/auth/screens/role_selection_screen.dart';
import 'package:flutter_wordsaloud/features/home/screens/edit_profile_screen.dart';

class TradesmanDashboard extends StatefulWidget {
  final String tradesmanName;
  final String tradesmanSkill;
  final String homeArea;
  final String? profileImagePath;

  const TradesmanDashboard({
    super.key,
    this.tradesmanName = 'Devon Ramsaran',
    this.tradesmanSkill = 'Plumber',
    this.homeArea = 'San Fernando',
    this.profileImagePath,
  });

  @override
  State<TradesmanDashboard> createState() => _TradesmanDashboardState();
}

class _TradesmanDashboardState extends State<TradesmanDashboard> {
  late String _tradesmanName;
  late String _tradesmanSkill;
  late String _homeArea;
  String? _profileImagePath;
  String _pitch = '';
  List<String> _extraTrades = const [];
  String _rate = '';
  String _rateUnit = 'per day';

  @override
  void initState() {
    super.initState();
    _tradesmanName = widget.tradesmanName;
    _tradesmanSkill = widget.tradesmanSkill;
    _homeArea = widget.homeArea;
    _profileImagePath = widget.profileImagePath;
  }

  // Extract initials for the avatar (e.g. Devon Ramsaran -> DR)
  String _getInitials(String name) {
    if (name.isEmpty) return 'TR';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final firstInitial = parts[0].isNotEmpty ? parts[0][0] : '';
      final lastInitial = parts[parts.length - 1].isNotEmpty
          ? parts[parts.length - 1][0]
          : '';
      return (firstInitial + lastInitial).toUpperCase();
    }
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'TR';
  }

  // Format the name showing first name and last name initial (e.g. Devon Ramsaran -> Devon R.)
  String _formatName(String name) {
    if (name.isEmpty) return 'Tradesman';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts[0];
      final lastInitial = parts[parts.length - 1].isNotEmpty
          ? '${parts[parts.length - 1][0]}.'
          : '';
      return '$first $lastInitial';
    }
    return parts[0];
  }

  @override
  Widget build(BuildContext context) {
    final displaySkill = _tradesmanSkill.isNotEmpty ? _tradesmanSkill : 'Plumber';
    final displayArea = _homeArea.isNotEmpty ? _homeArea : 'San Fernando';
    final displaySub = '$displaySkill • $displayArea';

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Cream background
      body: Column(
        children: [
          // ── Header (Red/Brown Background) ─────────────────
          Container(
            color: const Color(0xFFAE3F30), // consistent with home screen header
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
              top: 54,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY DASHBOARD',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Golden/orange avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5C77A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _profileImagePath != null &&
                          _profileImagePath!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_profileImagePath!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Center(
                        child: Text(
                          _getInitials(_tradesmanName),
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Name & Skill details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatName(_tradesmanName),
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            displaySub,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Verified badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22707F), // Teal verified badge color
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 11,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Scrollable Body ──────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Overall Rating Card
                  Container(
                    margin: const EdgeInsets.only(left: 18, right: 18, top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E), // Dark charcoal
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '4.9',
                          style: GoogleFonts.outfit(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFEAAE4B),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                    (index) => const Icon(
                                  Icons.star,
                                  color: Color(0xFFEAAE4B),
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'OVERALL RATING',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '87 reviews',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. Views/Trades Row
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            emojiOrAsset: '👁️',
                            emojiColor: const Color(0xFFFDE8E8),
                            number: '42',
                            label: 'VIEWS THIS WEEK',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildStatCard(
                            emojiOrAsset: '🔧',
                            emojiColor: const Color(0xFFE3F2FD),
                            number: '3',
                            label: 'TRADES LISTED',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Rating breakdown Card
                  Container(
                    margin: const EdgeInsets.only(left: 18, right: 18, top: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFF3E5CF),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rating breakdown',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '87 reviews total',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: const Color(0xFF6D6D6D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _buildBreakdownRow('5', 0.86, '75'),
                        const SizedBox(height: 8),
                        _buildBreakdownRow('4', 0.10, '9'),
                        const SizedBox(height: 8),
                        _buildBreakdownRow('3', 0.02, '2'),
                        const SizedBox(height: 8),
                        _buildBreakdownRow('2', 0.01, '1'),
                        const SizedBox(height: 8),
                        _buildBreakdownRow('1', 0.00, '0'),
                      ],
                    ),
                  ),

                  // 4. Recent Reviews Section
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 8),
                    child: Text(
                      'RECENT REVIEWS',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF6D6D6D),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  _buildReviewCard(
                    reviewer: 'Marcia J.',
                    stars: 5,
                    description: 'Came same day, fix the leak in 20 mins. Fair price too.',
                    timeAgo: '2 days ago',
                  ),
                  const SizedBox(height: 10),
                  _buildReviewCard(
                    reviewer: 'Anthony P.',
                    stars: 5,
                    description: 'Solid work, doh make joke. Would call again.',
                    timeAgo: '5 days ago',
                  ),

                  // 5. Quick Actions Section
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 8),
                    child: Text(
                      'QUICK ACTIONS',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF6D6D6D),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  _buildActionCard(
                    title: 'Edit my profile',
                    subtitle: 'Update bio, rate, trades, area, photo',
                    icon: Icons.edit_outlined,
                    iconBg: const Color(0xFFFCE4EC),
                    onTap: () async {
                      final result = await Get.to(() => TradesmanEditProfileScreen(
                        tradesmanName: _tradesmanName,
                        tradesmanPhone: '+1 868 754-2288',
                        tradesmanSkill: _tradesmanSkill,
                        homeArea: _homeArea,
                        profileImagePath: _profileImagePath,
                      ));
                      if (result != null && result is Map) {
                        setState(() {
                          if (result['mainTrade'] != null) {
                            _tradesmanSkill = result['mainTrade'];
                          }
                          if (result['homeArea'] != null) {
                            _homeArea = result['homeArea'];
                          }
                          if (result['profileImagePath'] != null) {
                            _profileImagePath = result['profileImagePath'];
                          }
                          if (result['pitch'] != null) {
                            _pitch = result['pitch'];
                          }
                          if (result['rate'] != null) {
                            _rate = result['rate'];
                          }
                          if (result['rateUnit'] != null) {
                            _rateUnit = result['rateUnit'];
                          }
                          if (result['extraTrades'] != null) {
                            _extraTrades = List<String>.from(result['extraTrades']);
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildActionCard(
                    title: 'Preview my public profile',
                    subtitle: 'See what clients see',
                    icon: Icons.visibility_outlined,
                    iconBg: const Color(0xFFFFF9C4),
                    onTap: () {
                      Get.to(() => TradesmanPublicviewScreen(
                        name: _tradesmanName,
                        location: displayArea,
                        avatarLetter: _getInitials(_tradesmanName),
                        rating: '4.9',
                        categoryName: displaySkill,
                        pitch: _pitch,
                        extraTrades: _extraTrades,
                        rate: _rate,
                        rateUnit: _rateUnit,
                      ));
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildActionCard(
                    title: 'Switch to customer view',
                    subtitle: 'Browse tradesmen as a client',
                    icon: Icons.swap_horiz,
                    iconBg: const Color(0xFFE0F2F1),
                    onTap: () {
                      Get.offAll(() => const HomeScreen());
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildActionCard(
                    title: 'Sign out',
                    subtitle: '',
                    icon: Icons.logout,
                    iconBg: const Color(0xFFFFEBEE),
                    textColor: const Color(0xFFA83F2D),
                    hideArrow: true,
                    onTap: () {
                      Get.offAll(() => const RoleSelectionScreen());
                    },
                  ),

                  const SizedBox(height: 28),

                  // 6. Days badge / Footer
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBD7C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Color(0xFF5A493B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '14 days on Aturservicett',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF5A493B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for View/Trades stats card
  Widget _buildStatCard({
    required String emojiOrAsset,
    required Color emojiColor,
    required String number,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF3E5CF),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: emojiColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emojiOrAsset,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            number,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6D6D6D),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for Rating Breakdown bar
  Widget _buildBreakdownRow(String starText, double percentage, String countText) {
    return Row(
      children: [
        SizedBox(
          width: 12,
          child: Text(
            starText,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.star,
          color: Color(0xFFEAAE4B),
          size: 15,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE6),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 12,
                    width: constraints.maxWidth * percentage,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAE3F30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 20,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              countText,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for Review card
  Widget _buildReviewCard({
    required String reviewer,
    required int stars,
    required String description,
    required String timeAgo,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF3E5CF),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reviewer,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
              Row(
                children: List.generate(
                  stars,
                      (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFEAAE4B),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            timeAgo,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6D6D6D),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for Quick Action items
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required VoidCallback onTap,
    Color? textColor,
    bool hideArrow = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF3E5CF),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: textColor ?? const Color(0xFF454545),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor ?? Colors.black,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: const Color(0xFF6D6D6D),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!hideArrow)
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFCDCDCD),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
