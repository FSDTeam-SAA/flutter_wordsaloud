import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/core/common/widgets/press_back_to_exit.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/dashboard_response_model.dart'
    as dashboard_model;
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tradesman_edit_profile_screen.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/screens/tradesman_publicview_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/features/home/screens/home_screen.dart';

class TradesmanDashboard extends StatefulWidget {
  final String tradesmanName;
  final String tradesmanSkill;
  final List<String> extraTrades;
  final String homeArea;
  final String? profileImagePath;

  const TradesmanDashboard({
    super.key,
    this.tradesmanName = 'Devon Ramsaran',
    this.tradesmanSkill = 'Plumber',
    this.extraTrades = const [],
    this.homeArea = 'San Fernando',
    this.profileImagePath,
  });

  @override
  State<TradesmanDashboard> createState() => _TradesmanDashboardState();
}

class _TradesmanDashboardState extends State<TradesmanDashboard> {
  late final TradesmanController _controller;
  late String _tradesmanName;
  late String _tradesmanSkill;
  late String _homeArea;
  String? _profileImagePath;
  String? _profileImageUrl;
  String _verificationStatus = 'Pending Verification';
  String _pitch = '';
  List<String> _extraTrades = const [];
  String _rate = '';
  String _rateUnit = 'per day';
  List<String> _recentWorkPhotoUrls = const [];
  num _overallRating = 0;
  int _reviewsTotal = 0;
  int _jobsCount = 0;
  int _viewsThisWeek = 0;
  int _tradesListed = 3;
  int _daysOnPlatform = 0;
  List<dashboard_model.RatingBreakdown> _ratingBreakdown = const [];
  List<dashboard_model.RecentReview> _recentReviews = const [];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<TradesmanController>();
    _tradesmanName = widget.tradesmanName;
    _tradesmanSkill = widget.tradesmanSkill;
    _extraTrades = widget.extraTrades;
    _homeArea = widget.homeArea;
    _profileImagePath = widget.profileImagePath;
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final dashboard = await _controller.fetchDashboard();
    if (!mounted || dashboard == null) return;

    _applyDashboard(dashboard);
  }

  void _applyDashboard(dashboard_model.TradesmanDashboardResponse dashboard) {
    final profile = dashboard.profile;
    final user = profile?.user;
    final first = user?.firstName?.trim() ?? '';
    final last = user?.lastName?.trim() ?? '';
    final fullName = (user?.name?.trim().isNotEmpty ?? false)
        ? user!.name!.trim()
        : [first, last].where((value) => value.isNotEmpty).join(' ');
    final amount = profile?.typicalRate?.amount;

    setState(() {
      if (fullName.isNotEmpty) _tradesmanName = fullName;
      if (profile?.mainSkill?.trim().isNotEmpty ?? false) {
        _tradesmanSkill = profile!.mainSkill!.trim();
      }
      if (profile?.homeArea?.trim().isNotEmpty ?? false) {
        _homeArea = profile!.homeArea!.trim();
      }
      if (profile?.pitch?.trim().isNotEmpty ?? false) {
        _pitch = profile!.pitch!.trim();
      }
      if (profile?.extraSkills != null) {
        _extraTrades = profile!.extraSkills!;
      }
      if (amount != null) {
        _rate = _formatNumber(amount);
      }
      if (profile?.typicalRate?.unit?.trim().isNotEmpty ?? false) {
        _rateUnit = profile!.typicalRate!.unit!.trim();
      }
      _recentWorkPhotoUrls =
          profile?.workPhotos
              ?.map((photo) => photo.url)
              .whereType<String>()
              .where((url) => url.trim().isNotEmpty)
              .toList() ??
          const [];
      _profileImageUrl = user?.profileImage?.url;
      _verificationStatus =
          dashboard.verification?.label ??
          _formatStatusLabel(
            dashboard.verification?.status ?? profile?.verificationStatus,
          );
      _overallRating = dashboard.overallRating ?? profile?.ratingAverage ?? 0;
      _reviewsTotal = dashboard.reviewsTotal ?? profile?.ratingCount ?? 0;
      _jobsCount = profile?.jobsCount ?? 0;
      _viewsThisWeek = dashboard.viewsThisWeek ?? 0;
      _tradesListed = dashboard.tradesListed ?? _tradesListed;
      _daysOnPlatform = dashboard.daysOnPlatform ?? 0;
      _ratingBreakdown = dashboard.ratingBreakdown ?? const [];
      _recentReviews = dashboard.recentReviews ?? const [];
    });
  }

  String _formatNumber(num value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  String _formatRating(num value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  int _ratingCountValue(int star) {
    for (final item in _ratingBreakdown) {
      if (item.star == star) return item.count ?? 0;
    }
    return 0;
  }

  String _ratingCount(int star) {
    return _ratingCountValue(star).toString();
  }

  double _ratingPercent(int star) {
    if (_reviewsTotal <= 0) return 0;
    return _ratingCountValue(star) / _reviewsTotal;
  }

  Widget _buildAvatarInitials() {
    return Center(
      child: Text(
        _getInitials(_tradesmanName),
        style: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }

  String _formatStatusLabel(String? status) {
    final value = status?.trim();
    if (value == null || value.isEmpty) return 'Pending Verification';
    return value
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  Color _verificationColor(String status) {
    final value = status.toLowerCase();
    if (value.contains('verified') || value.contains('approved')) {
      return const Color(0xFF22707F);
    }
    if (value.contains('reject') || value.contains('declined')) {
      return const Color(0xFFA83F2D);
    }
    return const Color(0xFF6C5D4A);
  }

  String _reviewerDisplayName(String? name) {
    final value = name?.trim();
    if (value == null || value.isEmpty) return 'Client';
    final parts = value.split(RegExp(r'\s+'));
    if (parts.length < 2) return parts.first;
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }

  String _timeAgo(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return '';

    final difference = DateTime.now().difference(parsed.toLocal());
    if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    }
    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
    return 'Just now';
  }

  int _clampedStars(int stars) {
    return stars.clamp(0, 5);
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
    final displaySkill = _tradesmanSkill.isNotEmpty
        ? _tradesmanSkill
        : 'Plumber';
    final displayArea = _homeArea.isNotEmpty ? _homeArea : 'San Fernando';
    final displaySub = '$displaySkill • $displayArea';
    final displayRating = _formatRating(_overallRating);

    return PressBackToExit(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5EFE6), // Cream background
        body: Column(
          children: [
            // ── Header (Red/Brown Background) ─────────────────
            Container(
              color: const Color(
                0xFFAE3F30,
              ), // consistent with home screen header
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
                        child:
                            _profileImagePath != null &&
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
                            : _profileImageUrl != null &&
                                  _profileImageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  _profileImageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      _buildAvatarInitials(),
                                ),
                              )
                            : _buildAvatarInitials(),
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
                                color: Colors.white.withValues(alpha: 0.9),
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
                                color: _verificationColor(_verificationStatus),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    _verificationStatus,
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
                      margin: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 20,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), // Dark charcoal
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            displayRating,
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
                                  (index) => Icon(
                                    Icons.star,
                                    color: index < _overallRating.round()
                                        ? const Color(0xFFEAAE4B)
                                        : Colors.white.withValues(alpha: 0.35),
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
                                '$_reviewsTotal reviews',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.70),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 2. Views/Trades Row
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              emojiOrAsset: '👁️',
                              emojiColor: const Color(0xFFFDE8E8),
                              number: _viewsThisWeek.toString(),
                              label: 'VIEWS THIS WEEK',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildStatCard(
                              emojiOrAsset: '🔧',
                              emojiColor: const Color(0xFFE3F2FD),
                              number: _tradesListed.toString(),
                              label: 'TRADES LISTED',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Rating breakdown Card
                    Container(
                      margin: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 16,
                      ),
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
                                '$_reviewsTotal reviews total',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: const Color(0xFF6D6D6D),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _buildBreakdownRow(
                            '5',
                            _ratingPercent(5),
                            _ratingCount(5),
                          ),
                          const SizedBox(height: 8),
                          _buildBreakdownRow(
                            '4',
                            _ratingPercent(4),
                            _ratingCount(4),
                          ),
                          const SizedBox(height: 8),
                          _buildBreakdownRow(
                            '3',
                            _ratingPercent(3),
                            _ratingCount(3),
                          ),
                          const SizedBox(height: 8),
                          _buildBreakdownRow(
                            '2',
                            _ratingPercent(2),
                            _ratingCount(2),
                          ),
                          const SizedBox(height: 8),
                          _buildBreakdownRow(
                            '1',
                            _ratingPercent(1),
                            _ratingCount(1),
                          ),
                        ],
                      ),
                    ),

                    // 4. Recent Reviews Section
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 22,
                        bottom: 8,
                      ),
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

                    if (_recentReviews.isEmpty)
                      _buildNoReviewsCard()
                    else
                      ..._recentReviews.map(
                        (review) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildReviewCard(
                            reviewer: _reviewerDisplayName(review.reviewerName),
                            stars: review.rating ?? 0,
                            description:
                                review.comment?.trim().isNotEmpty ?? false
                                ? review.comment!.trim()
                                : 'No comment provided.',
                            timeAgo: _timeAgo(review.createdAt),
                          ),
                        ),
                      ),

                    // 5. Quick Actions Section
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 22,
                        bottom: 8,
                      ),
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
                        final result = await Get.to(
                          () => TradesmanEditProfileScreen(
                            tradesmanName: _tradesmanName,
                            tradesmanPhone: '+1 868 754-2288',
                            tradesmanSkill: _tradesmanSkill,
                            extraTrades: _extraTrades,
                            homeArea: _homeArea,
                            profileImagePath: _profileImagePath,
                          ),
                        );
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
                              _profileImageUrl = null;
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
                              _extraTrades = List<String>.from(
                                result['extraTrades'],
                              );
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
                        Get.to(
                          () => TradesmanPublicviewScreen(
                            name: _tradesmanName,
                            location: displayArea,
                            avatarLetter: _getInitials(_tradesmanName),
                            profileImagePath: _profileImagePath,
                            profileImageUrl: _profileImageUrl,
                            rating: displayRating,
                            reviewsCount: _reviewsTotal,
                            jobsCount: _jobsCount,
                            categoryName: displaySkill,
                            pitch: _pitch,
                            extraTrades: _extraTrades,
                            recentWorkPhotoUrls: _recentWorkPhotoUrls,
                            rate: _rate,
                            rateUnit: _rateUnit,
                            showPreviewBanner: true,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildActionCard(
                      title: 'Switch to customer view',
                      subtitle: 'Browse tradesmen as a client',
                      icon: Icons.swap_horiz,
                      iconBg: const Color(0xFFE0F2F1),
                      onTap: () {
                        Get.to(
                          () => const HomeScreen(showCustomerModeBanner: true),
                        );
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
                        _controller.signOut();
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
                              '$_daysOnPlatform days on Aturservicett',
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
        border: Border.all(color: const Color(0xFFF3E5CF), width: 1.5),
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
              child: Text(emojiOrAsset, style: const TextStyle(fontSize: 18)),
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
  Widget _buildBreakdownRow(
    String starText,
    double percentage,
    String countText,
  ) {
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
        const Icon(Icons.star, color: Color(0xFFEAAE4B), size: 15),
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
  Widget _buildNoReviewsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3E5CF), width: 1.5),
      ),
      child: Text(
        'No reviews available.',
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6D6D6D),
        ),
      ),
    );
  }

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
        border: Border.all(color: const Color(0xFFF3E5CF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  reviewer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: List.generate(
                  _clampedStars(stars),
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
        border: Border.all(color: const Color(0xFFF3E5CF), width: 1.5),
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
