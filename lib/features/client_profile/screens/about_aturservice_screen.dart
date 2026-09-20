import 'package:flutter/material.dart';
import 'package:aturservicett/features/client_profile/widgets/header.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/about_aturservice_controller.dart';

class AboutAturserviceScreen extends StatelessWidget {
  const AboutAturserviceScreen({super.key});

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _headerColor = Color(0xFFBC4437);
  static const _darkText = Color(0xFF221C18);
  static const _mutedText = Color(0xFF7A7470);
  static const _borderColor = Color(0xFFD3C7BD);
  static const _goldColor = Color(0xFFF4BC42);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutAturserviceController());

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          Hearder(
            headerColor: _headerColor,
            goldColor: _goldColor,
            text1: 'About ',
            text2: 'Aturservicett',
            suvbtitle: 'Skilled professionals at your service',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFE5A742),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            '🧰',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.outfit(
                              color: _darkText,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                            children: const [
                              TextSpan(text: 'Aturservice'),
                              TextSpan(
                                text: 'tt',
                                style: TextStyle(
                                  color: _headerColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => Text(
                            controller.headerSubtitle.value,
                            style: GoogleFonts.outfit(
                              color: _mutedText,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => _MissionCard(
                      title: controller.missionTitle.value,
                      body: controller.missionBody.value,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => _StatsCard(stats: controller.stats.toList())),
                  const SizedBox(height: 22),
                  Obx(
                    () => _FoundersNote(
                      note: controller.foundersNote.value,
                      signature: controller.foundersSignature.value,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _SectionLabel('GET IN TOUCH'),
                  const SizedBox(height: 14),
                  Obx(
                    () => _ContactCard(
                      title: controller.contactTitle.value,
                      subtitle: controller.contactSubtitle.value,
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

class AboutStat {
  const AboutStat({required this.value, required this.label});

  final String value;
  final String label;
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: AboutAturserviceScreen._headerColor,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.outfit(
              color: AboutAturserviceScreen._darkText,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.stats});

  final List<AboutStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _lightBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) => _StatItem(stat: stat)).toList(),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat});

  final AboutStat stat;

  @override
  Widget build(BuildContext context) {
    final isFlag = stat.value.contains('🇹🇹');

    return Expanded(
      child: Column(
        children: [
          Text(
            stat.value,
            style: GoogleFonts.outfit(
              color: isFlag
                  ? AboutAturserviceScreen._darkText
                  : AboutAturserviceScreen._headerColor,
              fontSize: isFlag ? 18 : 17,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.label,
            style: GoogleFonts.outfit(
              color: AboutAturserviceScreen._mutedText,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}

class _FoundersNote extends StatelessWidget {
  const _FoundersNote({required this.note, required this.signature});

  final String note;
  final String signature;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF211D19),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A note from the founders',
            style: GoogleFonts.outfit(
              color: AboutAturserviceScreen._goldColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            note,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            signature,
            style: GoogleFonts.outfit(
              color: AboutAturserviceScreen._goldColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
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
        color: AboutAturserviceScreen._mutedText,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
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
            style: GoogleFonts.outfit(
              color: AboutAturserviceScreen._darkText,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AboutAturserviceScreen._darkText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: AboutAturserviceScreen._headerColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.email, color: Colors.white, size: 12),
                const SizedBox(width: 5),
                Text(
                  email,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
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

const _lightBorder = AboutAturserviceScreen._borderColor;
