import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/home/screens/post_review_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TradesmanDetailsScreen extends StatelessWidget {
  final String name;
  final String location;
  final String avatarLetter;
  final String rating;
  final String categoryName;
  final String pitch;
  final List<String> extraTrades;
  final String rate;
  final String rateUnit;

  const TradesmanDetailsScreen({
    super.key,
    required this.name,
    required this.location,
    required this.avatarLetter,
    required this.rating,
    required this.categoryName,
    this.pitch = '',
    this.extraTrades = const [],
    this.rate = '',
    this.rateUnit = 'per day',
  });

  // Map skill name -> asset image, matching WhatDoScreen
  String _getTradeImage(String tradeName) {
    switch (tradeName.toLowerCase().trim()) {
      case 'phone tech':    return 'assets/images/fi_5060325.png';
      case 'computer tech': return 'assets/images/fi_10528057.png';
      case 'plumber':       return 'assets/images/fi_6342703.png';
      case 'electrician':   return 'assets/images/fi_9781304.png';
      case 'carpenter':     return 'assets/images/fi_12479483.png';
      case 'joinery':       return 'assets/images/fi_14106303.png';
      case 'mobile mech':   return 'assets/images/fi_186239.png';
      case 'painter':       return 'assets/images/fi_1995467.png';
      case 'appliance':     return 'assets/images/fi_2012957.png';
      case 'ac tech':       return 'assets/images/fi_7969720.png';
      case 'tile man':      return 'assets/images/fi_11932525.png';
      case 'mason':         return 'assets/images/fi_18029670.png';
      case 'glass man':     return 'assets/images/fi_896123.png';
      case 'roofer':        return 'assets/images/fi_14620736.png';
      case 'welder/gate':   return 'assets/images/fi_9439147.png';
      case 'pool cleaner':  return 'assets/images/fi_15551378.png';
      case 'tree cutter':   return 'assets/images/fi_6327310.png';
      case 'landscaper':    return 'assets/images/fi_10033506.png';
      case 'auto body':     return 'assets/images/fi_6332022.png';
      case 'contractor':    return 'assets/images/fi_4490380.png';
      default:              return 'assets/images/fi_5060325.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use pitch if provided, otherwise fall back to a generated description
    final String formattedCategory = categoryName.endsWith('s')
        ? categoryName.substring(0, categoryName.length - 1).toLowerCase()
        : categoryName.toLowerCase();

    final String aboutText = pitch.isNotEmpty
        ? pitch
        : 'Skilled $formattedCategory experienced in both home and business work. Strong track record and ready to bring top-quality work to your team.';

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      body: Column(
        children: [
          // ── Header Section ──────────────────────────────────────────────
          Container(
            height: 206,
            width: double.infinity, 
            color: const Color(0xFF245869),
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
              top: 52,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
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
                      const Text(
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
                const SizedBox(height: 20),

                // Profile Info Row
                Row(
                  children: [
                    // Avatar Box with orange/yellow gradient
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
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
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$categoryName • $location',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xD8FFFFFF),
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
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 18),
                              const Text(
                                '87 Reviews',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xD8FFFFFF),
                                ),
                              ),
                              const SizedBox(width: 18),
                              const Text(
                                '142 jobs',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xD8FFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Scrollable Body Section ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 24,
                bottom: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Header
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // About Body Text
                  Text(
                    aboutText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                      color: Color(0xFF787878),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Also Does Section ──────────────────────────
                  if (extraTrades.isNotEmpty) ...[
                    Text(
                      'Also does',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: extraTrades.map((trade) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFF3E5CF),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                _getTradeImage(trade),
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                trade,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Rate Section ───────────────────────────────
                  if (rate.isNotEmpty) ...[
                    Text(
                      'Rate',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EFE6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFEBD7C7),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'TT\$$rate',
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1E1E1E),
                                  ),
                                ),
                                TextSpan(
                                  text: ' / $rateUnit',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF8D7766),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Starting rate — final quote per job.',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8D7766),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // WhatsApp Button
                  GestureDetector(
                    onTap: () {
                      // WhatsApp redirection placeholder
                    },
                    child: Container(
                      height: 51,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2DCF66),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/wapp_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Message on WhatsApp',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Call directly Button
                  GestureDetector(
                    onTap: () {
                      // Call directly placeholder
                    },
                    child: Container(
                      height: 51,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1716),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 23.95,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Call directly',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recent work Title
                  const Text(
                    'Recent work',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Horizontal Recent Work Boxes
                  SizedBox(
                    height: 106.08,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildRecentWorkPhoto(),
                        const SizedBox(width: 12),
                        _buildRecentWorkPhoto(),
                        const SizedBox(width: 12),
                        _buildRecentWorkPhoto(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reviews Title
                  Row(
                    children: [
                      const Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        ),
                      ),
                      Spacer(),
                      TextButton(onPressed: (){Get.to(() => PostReviewScreen());}, child: Text('Add Review'))
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Card representing review
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFF3E5CF),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rishi L.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
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
                        const Text(
                          'Came same day, fix the leak in 20mins.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6C6C6C),
                          ),
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

  Widget _buildRecentWorkPhoto() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFFDDD5C8),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
