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
                    answer: 'Tap "I am a tradesman" on the welcome screen, enter your email address for verification, then complete your profile with your trades, service area, rate, and a short bio. You will be live immediately with a "Pending verification" badge until we manually verify your details.',
                  ),
                  SizedBox(height: 8),
                  _FaqItem(index: 1, question: 'How do I find a tradesman?',
                    answer:  'From the browse home screen, tap the trade you need — plumber, electrician, mechanic, and so on. You will see a list of tradesmen in your area with their ratings and reviews. Tap any tradesman to view their full profile, then tap the WhatsApp button to message them directly',),
                  SizedBox(height: 8),
                  _FaqItem(index: 2, question: 'Is Aturservicett free to use?',
                    answer: "Yes. Aturservicett is completely free for both clients and tradesmen. You can browse, contact tradesmen, and leave reviews at no cost. Tradesmen can also list their services for free. We do not take any commission on jobs, and we do not charge for signup or standard listings.",),
                  SizedBox(height: 14),
                  _SectionLabel('CONTACTING TRADESMEN'),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 3,
                    question: 'Does Aturservicett handle payments?',
                    answer: 'No. Aturservicett is a directory that connects clients with tradesmen. All payments are made directly between you and the tradesman using whatever method you both agree on — cash, bank transfer, or otherwise. We do not process, hold, or facilitate payments, and we do not take any commission.',
                  ),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 4,
                    question: 'What if the tradesman doesn\'t respond?',
                    answer: "Tradesmen are independent professionals — we do not guarantee response times. If a tradesman does not respond within a reasonable period, we recommend contacting another tradesman from the same trade. You can also report an unresponsive tradesman by emailing support@aturservicett.com so we can follow up.",
                  ),
                  SizedBox(height: 14),
                  _SectionLabel('REVIEWS & RATINGS'),
                  SizedBox(height: 8),
                  _FaqItem(index: 5, question: 'How do I leave a review?', answer: "After you have engaged a tradesman through the app, you can leave a review from their profile page. Tap the \"Leave a review\" option, give a star rating from 1 to 5, and add a written review of your experience. Reviews help other clients make informed choices and help great tradesmen build their reputation.",),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 6,
                    question: 'Can I edit or delete my review?',
                    answer: "Yes. To edit or remove a review you have posted, email support@aturservicett.com with your name, the tradesman's name, and the change you would like made. Our team will process your request within 1-2 business days. We do not allow edits initiated by the tradesman being reviewed.",
                  ),
                  SizedBox(height: 14),
                  _SectionLabel('ACCOUNT'),
                  SizedBox(height: 8),
                  _FaqItem(
                    index: 7,
                    question: 'How do I change my email address?',
                    answer: "For account security, email address changes are handled by our support team. Email support@aturservicett.com from your current registered email address with the new email you would like to use. We will verify and update your account within 1-2 business days.",
                  ),
                  SizedBox(height: 8),
                  _FaqItem(index: 8, question: 'How do I delete my account?', answer: "To delete your account, email support@aturservicett.com from your registered email address with \"Account deletion request\" in the subject line. We will permanently remove your account and personal information within 30 days, in line with our Privacy Policy. Reviews you have posted may remain visible in anonymized form.",),
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
