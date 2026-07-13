import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TradesmanDetailsScreen extends StatelessWidget {
  final String name;
  final String location;
  final String avatarLetter;
  final String rating;
  final String categoryName;

  const TradesmanDetailsScreen({
    super.key,
    required this.name,
    required this.location,
    required this.avatarLetter,
    required this.rating,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    // Generate some mock about description matching the tradesman
    final String formattedCategory = categoryName.endsWith('s')
        ? categoryName.substring(0, categoryName.length - 1).toLowerCase()
        : categoryName.toLowerCase();

    final String aboutText =
        'Skilled $formattedCategory experienced in both home and business plumbing. Strong track record of fixing pipe systems. Expert at reading blueprints and following safety rules. Ready to bring top-quality work to your team.';

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
                  const SizedBox(height: 16),

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
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
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
