import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/home/screens/post_review_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_specific_tradesman_response_model.dart'
    as specific_model;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TradesmanDetailsScreen extends StatefulWidget {
  final String? tradesmanId;
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
    this.tradesmanId,
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

  @override
  State<TradesmanDetailsScreen> createState() => _TradesmanDetailsScreenState();
}

class _TradesmanDetailsScreenState extends State<TradesmanDetailsScreen> {
  late final TradesmanController _tradesmanController;

  @override
  void initState() {
    super.initState();
    _tradesmanController = Get.find<TradesmanController>();
    final tradesmanId = widget.tradesmanId;
    if (tradesmanId != null && tradesmanId.trim().isNotEmpty) {
      _tradesmanController.getSingleTradesman(tradesmanId);
    }
  }

  // Map skill name -> asset image, matching WhatDoScreen
  String _getTradeImage(String tradeName) {
    switch (tradeName.toLowerCase().trim()) {
      case 'phone tech':
        return 'assets/images/fi_5060325.png';
      case 'computer tech':
        return 'assets/images/fi_10528057.png';
      case 'plumber':
        return 'assets/images/fi_6342703.png';
      case 'electrician':
        return 'assets/images/fi_9781304.png';
      case 'carpenter':
        return 'assets/images/fi_12479483.png';
      case 'joinery':
        return 'assets/images/fi_14106303.png';
      case 'mobile mech':
        return 'assets/images/fi_186239.png';
      case 'painter':
        return 'assets/images/fi_1995467.png';
      case 'appliance':
        return 'assets/images/fi_2012957.png';
      case 'ac tech':
        return 'assets/images/fi_7969720.png';
      case 'tile man':
        return 'assets/images/fi_11932525.png';
      case 'mason':
        return 'assets/images/fi_18029670.png';
      case 'glass man':
        return 'assets/images/fi_896123.png';
      case 'roofer':
        return 'assets/images/fi_14620736.png';
      case 'welder/gate':
        return 'assets/images/fi_9439147.png';
      case 'pool cleaner':
        return 'assets/images/fi_15551378.png';
      case 'tree cutter':
        return 'assets/images/fi_6327310.png';
      case 'landscaper':
        return 'assets/images/fi_10033506.png';
      case 'auto body':
        return 'assets/images/fi_6332022.png';
      case 'contractor':
        return 'assets/images/fi_4490380.png';
      default:
        return 'assets/images/fi_5060325.png';
    }
  }

  String _profileName(specific_model.Profile profile) {
    final user = profile.user;
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

  String _profileLocation(specific_model.Profile profile) {
    final area = profile.homeArea.trim().isNotEmpty
        ? profile.homeArea.trim()
        : profile.user.area.trim();
    return area.isNotEmpty ? area : 'Trinidad';
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'T';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _formatRating(num rating) {
    if (rating <= 0) return 'New';
    return rating % 1 == 0
        ? rating.toInt().toString()
        : rating.toStringAsFixed(1);
  }

  String _rateUnitLabel(String unit) {
    final normalized = unit.trim().toLowerCase();
    if (normalized.contains('hour')) return 'hour';
    if (normalized.contains('job')) return 'job';
    return 'day';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fetchedTradesman = _tradesmanController.getSpecificTradesman.value;
      final fetchedProfile = fetchedTradesman?.profile;
      final profile =
          widget.tradesmanId != null && fetchedProfile?.id == widget.tradesmanId
          ? fetchedProfile
          : null;
      final displayName = profile != null ? _profileName(profile) : widget.name;
      final displayLocation = profile != null
          ? _profileLocation(profile)
          : widget.location;
      final displayCategory = profile?.mainSkill.trim().isNotEmpty ?? false
          ? profile!.mainSkill
          : widget.categoryName;
      final displayAvatarLetter = _getInitials(displayName).isNotEmpty
          ? _getInitials(displayName)
          : widget.avatarLetter;
      final displayRating = profile != null
          ? _formatRating(profile.ratingAverage)
          : widget.rating;
      final displayReviewCount = profile?.ratingCount ?? 87;
      final displayJobsCount = profile?.jobsCount ?? 142;
      final displayPitch = profile?.pitch.trim().isNotEmpty ?? false
          ? profile!.pitch
          : widget.pitch;
      final displayExtraTrades = profile?.extraSkills ?? widget.extraTrades;
      final displayRate = profile != null && profile.typicalRate.amount > 0
          ? profile.typicalRate.amount.toString()
          : widget.rate;
      final displayRateUnit =
          profile != null && profile.typicalRate.unit.trim().isNotEmpty
          ? _rateUnitLabel(profile.typicalRate.unit)
          : widget.rateUnit;
      final effectiveTradesmanId = profile?.id ?? widget.tradesmanId ?? '';
      final recentWorkPhotoUrls =
          profile?.workPhotos
              .map(_workPhotoUrl)
              .where((url) => url.isNotEmpty)
              .toList() ??
          const <String>[];
      final reviews = profile != null
          ? fetchedTradesman?.reviews ?? const <specific_model.Review>[]
          : const <specific_model.Review>[];

      // Use pitch if provided, otherwise fall back to a generated description
      final String formattedCategory = displayCategory.endsWith('s')
          ? displayCategory
                .substring(0, displayCategory.length - 1)
                .toLowerCase()
          : displayCategory.toLowerCase();

      final String aboutText = displayPitch.isNotEmpty
          ? displayPitch
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
                            displayAvatarLetter,
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
                              displayName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$displayCategory • $displayLocation',
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
                                  displayRating,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Text(
                                  '$displayReviewCount ${displayReviewCount == 1 ? 'Review' : 'Reviews'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xD8FFFFFF),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Text(
                                  '$displayJobsCount ${displayJobsCount == 1 ? 'job' : 'jobs'}',
                                  style: const TextStyle(
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
                    if (displayExtraTrades.isNotEmpty) ...[
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
                        children: displayExtraTrades.map((trade) {
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
                    if (displayRate.isNotEmpty) ...[
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
                                    text: 'TT\$$displayRate',
                                    style: GoogleFonts.outfit(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / $displayRateUnit',
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
                            Icon(Icons.phone, color: Colors.white, size: 23.95),
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
                    if (recentWorkPhotoUrls.isEmpty)
                      _buildEmptyInfoCard('No recent work photos available.')
                    else
                      SizedBox(
                        height: 106.08,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: recentWorkPhotoUrls.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return _buildRecentWorkPhoto(
                              recentWorkPhotoUrls[index],
                            );
                          },
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
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => PostReviewScreen(
                                tradesmanId: effectiveTradesmanId,
                                tradesmanName: displayName,
                                trade: displayCategory,
                                avatarLetters: displayAvatarLetter,
                              ),
                            );
                          },
                          child: Text('Add Review'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (reviews.isEmpty)
                      _buildEmptyInfoCard('No review available')
                    else
                      ...reviews.map(
                        (review) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildReviewCard(review),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _workPhotoUrl(dynamic photo) {
    if (photo == null) return '';
    if (photo is String) return photo.trim();
    if (photo is Map) {
      final json = Map<String, dynamic>.from(photo);
      return (json['url'] ??
              json['secure_url'] ??
              json['imageUrl'] ??
              json['path'] ??
              '')
          .toString()
          .trim();
    }
    return '';
  }

  int _clampedStars(int stars) => stars.clamp(0, 5).toInt();

  Widget _buildRecentWorkPhoto(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 110,
            height: 110,
            color: const Color(0xFFDDD5C8),
            child: const Icon(Icons.broken_image, color: Color(0xFF8D7766)),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 110,
            height: 110,
            color: const Color(0xFFDDD5C8),
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyInfoCard(String text) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3E5CF), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6C6C6C),
        ),
      ),
    );
  }

  Widget _buildReviewCard(specific_model.Review review) {
    final comment = review.comment.trim().isNotEmpty
        ? review.comment.trim()
        : 'No comment provided.';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3E5CF), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  review.reviewerName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < _clampedStars(review.rating)
                        ? Icons.star
                        : Icons.star_border,
                    color: const Color(0xFFEAAE4B),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6C6C6C),
            ),
          ),
        ],
      ),
    );
  }
}
