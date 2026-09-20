import 'package:flutter/material.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PostReviewScreen extends StatelessWidget {
  const PostReviewScreen({
    super.key,
    this.tradesmanId = '',
    this.tradesmanName = 'Devon Ramcharan',
    this.trade = 'Plumber',
    this.lastContacted = 'Tue',
    this.avatarLetters = 'DR',
  });

  final String tradesmanId;
  final String tradesmanName;
  final String trade;
  final String lastContacted;
  final String avatarLetters;

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _accentColor = Color(0xFFCC4E3C);
  static const _darkText = Color(0xFF1F1F1F);
  static const _mutedText = Color(0xFF7E7267);
  static const _borderColor = Color(0xFFE3C9AD);
  static const _starColor = Color(0xFFEBAE3D);
  static const _tealColor = Color(0xFF2E7886);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PostReviewController(tradesmanId: tradesmanId),
      tag: tradesmanId,
    );
    final firstName = tradesmanName.split(' ').first;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: _mutedText,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Back',
                            style: GoogleFonts.outfit(
                              color: _mutedText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: controller.skipReview,
                      style: TextButton.styleFrom(
                        foregroundColor: _mutedText,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(42, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      color: _darkText,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                    children: [
                      const TextSpan(text: 'How was '),
                      TextSpan(
                        text: '$firstName?',
                        style: const TextStyle(
                          color: _accentColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your honest opinion helps other Trinis.',
                  style: GoogleFonts.outfit(
                    color: _darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                _TradesmanCard(
                  avatarLetters: avatarLetters,
                  name: tradesmanName,
                  subtitle: '$trade · Last contacted $lastContacted',
                ),
                const SizedBox(height: 28),
                Center(
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return GestureDetector(
                          onTap: () => controller.rating.value = starValue,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              starValue <= controller.rating.value
                                  ? Icons.star
                                  : Icons.star_border,
                              color: _starColor,
                              size: 31,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Obx(
                    () => Text(
                      controller.ratingLabel,
                      style: GoogleFonts.outfit(
                        color: _accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: controller.commentController,
                  minLines: 4,
                  maxLines: 5,
                  style: GoogleFonts.outfit(
                    color: _darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write a short review';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText:
                        'Example: Came on time, fixed the leak\nfast, fair price. Would call again.',
                    hintStyle: GoogleFonts.outfit(
                      color: const Color(0xFF9D948B),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
                    enabledBorder: _border(),
                    focusedBorder: _border(_starColor, 1.3),
                    errorBorder: _border(_accentColor, 1.2),
                    focusedErrorBorder: _border(_accentColor, 1.3),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isPosting.value
                          ? null
                          : controller.postReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: controller.isPosting.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Post review',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
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
    );
  }

  OutlineInputBorder _border([Color color = _borderColor, double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class PostReviewController extends GetxController {
  PostReviewController({required this.tradesmanId});

  final String tradesmanId;
  final formKey = GlobalKey<FormState>();
  final rating = 0.obs;
  final isPosting = false.obs;
  final commentController = TextEditingController();
  late final TradesmanController _tradesmanController =
      Get.find<TradesmanController>();

  String get ratingLabel {
    switch (rating.value) {
      case 1:
        return 'Poor';
      case 2:
        return 'Could be better';
      case 3:
        return 'Good';
      case 4:
        return 'Great — would recommend';
      case 5:
        return 'Excellent — would recommend';
      default:
        return 'Tap a star to rate';
    }
  }

  Future<void> postReview() async {
    if (rating.value < 1 || rating.value > 5) {
      Get.snackbar('Rating required', 'Please tap a star to choose a rating.');
      return;
    }

    if (!formKey.currentState!.validate()) return;
    if (tradesmanId.trim().isEmpty) {
      Get.snackbar('Review not posted', 'Tradesman profile not found.');
      return;
    }

    isPosting.value = true;
    final success = await _tradesmanController.addReview(
      tradesmanId: tradesmanId,
      rating: rating.value,
      ratingLabel: ratingLabel,
      reviewText: commentController.text.trim(),
    );
    isPosting.value = false;

    if (!success) {
      final message = _tradesmanController.errorMessage.value.trim();
      Get.snackbar(
        'Review not posted',
        message.isNotEmpty ? message : 'Please try again.',
      );
      return;
    }

    await _tradesmanController.getSingleTradesman(tradesmanId);
    Get.back(result: {'posted': true});
  }

  void skipReview() {
    Get.back(result: {'skipped': true});
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}

class _TradesmanCard extends StatelessWidget {
  const _TradesmanCard({
    required this.avatarLetters,
    required this.name,
    required this.subtitle,
  });

  final String avatarLetters;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: PostReviewScreen._borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PostReviewScreen._tealColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              avatarLetters,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: PostReviewScreen._darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: PostReviewScreen._mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
