import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/header.dart';

class HelpAndFaqScreen extends StatelessWidget {
  const HelpAndFaqScreen({super.key});

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _headerColor = Color(0xFFBC4437);
  static const _darkText = Color(0xFF221C18);
  static const _mutedText = Color(0xFF84796F);
  static const _borderColor = Color(0xFFD3C7BD);
  static const _goldColor = Color(0xFFF6C451);

  @override
  Widget build(BuildContext context) {
    Get.put(HelpAndFaqController());

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          Hearder(headerColor: _headerColor, goldColor: _goldColor, text1: 'Help & ', text2: 'FAQ', suvbtitle: 'Find quick answers or reach out support team',),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SectionLabel('GETTING STARTED'),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 0,
                    question: 'How do I sign up as a tradesman?',
                    answer: 'Tap "I am a tradesman" on the welcome screen, enter your phone number for verification, then complete your profile with your trades, service area, rate, and a short bio. You\'ll be live immediately with a "Pending verification" badge until we manually verify your details.',
                  ),
                  SizedBox(height: 8),
                  _FaqItem(index: 1, question: 'How do I find a tradesman?', answer:  'Tap "I am a tradesman" on the welcome screen, enter your phone number for verification, then complete your profile with your trades, service area, rate, and a short bio. You\'ll be live immediately with a "Pending verification" badge until we manually verify your details.',),
                  SizedBox(height: 8),
                  _FaqItem(index: 2, question: 'Is Aturservicett free to use?'),
                  SizedBox(height: 14),
                  _SectionLabel('CONTACTING TRADESMEN'),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 3,
                    question: 'Does Aturservicett handle payments?',
                  ),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 4,
                    question: 'What if the tradesman doesn\'t respond?',
                  ),
                  SizedBox(height: 14),
                  _SectionLabel('REVIEWS & RATINGS'),
                  SizedBox(height: 8),
                  _FaqItem(index: 5, question: 'How do I leave a review?'),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 6,
                    question: 'Can I edit or delete my review?',
                  ),
                  SizedBox(height: 14),
                  _SectionLabel('ACCOUNT'),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 7,
                    question: 'How do I change my phone number?',
                  ),
                  SizedBox(height: 8),
                  _FaqItem(index: 8, question: 'How do I delete my account?'),
                  SizedBox(height: 28),
                  _SupportCard(),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class HelpAndFaqController extends GetxController {
  final expandedIndexes = <int>{}.obs;

  bool isExpanded(int index) => expandedIndexes.contains(index);

  void toggle(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
    }
  }
}



class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: HelpAndFaqScreen._mutedText,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.index, required this.question, this.answer});

  final int index;
  final String question;
  final String? answer;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelpAndFaqController>();

    return Obx(() {
      final isExpanded = controller.isExpanded(index) && answer != null;

      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: () {
            if (answer == null) return;
            controller.toggle(index);
          },
          borderRadius: BorderRadius.circular(9),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(13, 13, 13, isExpanded ? 13 : 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: isExpanded
                    ? HelpAndFaqScreen._headerColor
                    : HelpAndFaqScreen._borderColor,
                width: isExpanded ? 1.2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                          color: HelpAndFaqScreen._darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isExpanded ? '-' : '+',
                      style: TextStyle(
                        color: HelpAndFaqScreen._headerColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Container(height: 1, color: const Color(0xFFE7D7C8)),
                      const SizedBox(height: 12),
                      Text(
                        answer ?? '',
                        style: TextStyle(
                          color: HelpAndFaqScreen._darkText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 160),
                  sizeCurve: Curves.easeOut,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEFD0C6)),
      ),
      child: Column(
        children: [
          Text(
            'Still need help?',
            style: GoogleFonts.outfit(
              color: HelpAndFaqScreen._darkText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Our team responds within 1-2 business days.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: HelpAndFaqScreen._darkText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: HelpAndFaqScreen._headerColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.email, color: Colors.white, size: 12),
                const SizedBox(width: 5),
                Text(
                  'support@aturservicett.com',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1,
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
