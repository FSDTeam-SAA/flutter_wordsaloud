import 'package:flutter/material.dart';
import 'package:aturservicett/features/client_profile/widgets/header.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/terms_and_privacy_controller.dart';

class TermsAndPrivacyScreen extends StatelessWidget {
  const TermsAndPrivacyScreen({super.key});

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _headerColor = Color(0xFFBC4437);
  static const _darkText = Color(0xFF221C18);
  static const _mutedText = Color(0xFF87817E);
  static const _borderColor = Color(0xFFCDC8C5);
  static const _goldColor = Color(0xFFF4BC42);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsAndPrivacyController());
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          Hearder(
            headerColor: _headerColor,
            goldColor: _goldColor,
            text1: 'Terms & ',
            text2: 'Privacy',
            suvbtitle: 'Our commitments to you and how we protect your data',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Column(
                      children: controller.policyItems
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 9),
                              child: _PolicyMenuItem(item: item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => _MattersCard(
                      title: controller.mattersTitle.value,
                      points: controller.mattersMost,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('QUESTIONS?'),
                  const SizedBox(height: 14),
                  Obx(
                    () => _QuestionsCard(
                      title: controller.questionsTitle.value,
                      subtitle: controller.questionsSubtitle.value,
                      email: controller.supportEmail.value,
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
}

class _PolicyMenuItem extends StatelessWidget {
  const _PolicyMenuItem({required this.item});

  final PolicyItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: item.onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: TermsAndPrivacyScreen._borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E8E3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.icon, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.outfit(
                        color: TermsAndPrivacyScreen._darkText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: TermsAndPrivacyScreen._mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: Color(0xFFB9A693),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MattersCard extends StatelessWidget {
  const _MattersCard({required this.title, required this.points});

  final String title;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TermsAndPrivacyScreen._borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: TermsAndPrivacyScreen._headerColor,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✓',
                    style: TextStyle(
                      color: TermsAndPrivacyScreen._headerColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        color: TermsAndPrivacyScreen._darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: TermsAndPrivacyScreen._mutedText,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        height: 1.2,
      ),
    );
  }
}

class _QuestionsCard extends StatelessWidget {
  const _QuestionsCard({
    required this.title,
    required this.subtitle,
    required this.email,
  });

  final String title;
  final String subtitle;
  final String email;

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
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TermsAndPrivacyScreen._darkText,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TermsAndPrivacyScreen._darkText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: TermsAndPrivacyScreen._headerColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.email, color: Colors.white, size: 12),
                const SizedBox(width: 5),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
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
