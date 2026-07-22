import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/client_profile/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndPrivacyScreen extends StatelessWidget {
  const TermsAndPrivacyScreen({super.key});

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _headerColor = Color(0xFFBC4437);
  static const _darkText = Color(0xFF221C18);
  static const _mutedText = Color(0xFF6F6760);
  static const _borderColor = Color(0xFFE3C9AD);
  static const _cardColor = Color(0xFFFFFCF8);
  static const _goldColor = Color(0xFFF4BC42);
  static const _supportEmail = 'support@aturservicett.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          const Hearder(
            headerColor: _headerColor,
            goldColor: _goldColor,
            text1: 'Privacy ',
            text2: 'Policy',
            suvbtitle: 'What we collect, why we collect it, and your rights',
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _IntroCard(),
                  SizedBox(height: 14),
                  _PolicySection(
                    title: '1. What We Collect',
                    paragraphs: [
                      _PolicyText(
                        label: 'When you sign up:',
                        text:
                            'your email address, first name and last name, and optionally your general area.',
                      ),
                      _PolicyText(
                        label: 'If you are a tradesman:',
                        text:
                            'the trades you offer, your service radius, your rate, a short bio, your phone number used for the WhatsApp button, and any photos you upload.',
                      ),
                      _PolicyText(
                        label: 'When you use the app:',
                        text:
                            'basic technical information about your device, and which screens you visit, used to keep the app working and to improve it.',
                      ),
                      _PolicyText(
                        label: 'When you contact us:',
                        text: 'the content of your emails to $_supportEmail.',
                      ),
                    ],
                  ),
                  _PolicySection(
                    title: '2. What We Do Not Collect',
                    bullets: [
                      'Your precise GPS location.',
                      'The contents of your WhatsApp conversations. Those are between you and the tradesman.',
                      'Your contacts, calendar, or camera roll.',
                      'Your payment card or bank information. We do not process payments.',
                    ],
                  ),
                  _PolicySection(
                    title: '3. How We Use Your Information',
                    intro: 'We use your information only for these reasons:',
                    bullets: [
                      'To register and log you in with email verification codes.',
                      'To let clients discover, browse, and contact tradesmen.',
                      'To display tradesman profiles, ratings, and reviews.',
                      'To send essential account notifications, never marketing.',
                      'To respond when you contact support.',
                      'To detect and prevent fraud, abuse, and violations of our Terms.',
                      'To comply with Trinidad & Tobago law.',
                      'To improve the app using anonymous, aggregated usage patterns.',
                    ],
                  ),
                  _ThirdPartySection(),
                  _PolicySection(
                    title: '5. How We Protect Your Information',
                    paragraphs: [
                      _PolicyText(
                        text:
                            'We use standard security measures including encrypted connections, encrypted storage, and access controls that limit who on our team can see your data. Since we use passwordless login with email verification codes, there is no user password to be stolen or leaked.',
                      ),
                      _PolicyText(
                        text:
                            'No system is 100% secure. If we ever have a data breach affecting you, we will notify you and the relevant authorities as required by law.',
                      ),
                    ],
                  ),
                  _PolicySection(
                    title: '6. How Long We Keep Your Information',
                    bullets: [
                      'Active accounts: for as long as your account exists.',
                      'Deleted accounts: personal information is removed within 90 days after account deletion, except where the law requires us to keep certain records longer.',
                      'Support emails: kept for up to 24 months after your issue is resolved.',
                      'Backups: may briefly contain deleted data before being overwritten in the normal course of backup rotation.',
                    ],
                  ),
                  _PolicySection(
                    title: '7. Your Rights',
                    intro:
                        'Under the Trinidad & Tobago Data Protection Act 2011, and consistent with international standards, you have the right to:',
                    bullets: [
                      'Ask what personal information we hold about you.',
                      'Ask us to correct information that is wrong or incomplete.',
                      'Ask us to delete your account and personal information.',
                      'Withdraw consent where we are processing your information because you consented.',
                      'Complain to the Office of the Information Commissioner of Trinidad & Tobago if you believe we mishandled your information.',
                    ],
                    footer:
                        'To exercise any of these rights, email us at $_supportEmail. We will respond within 30 days.',
                  ),
                  _PolicySection(
                    title: '8. Children',
                    paragraphs: [
                      _PolicyText(
                        text:
                            "Clients must be at least 13 years old. If you are under 18, we assume you have your parent's or guardian's permission.",
                      ),
                      _PolicyText(
                        label: 'Tradesmen',
                        text: 'must be at least 18 years old.',
                      ),
                      _PolicyText(
                        text:
                            "If you are a parent and believe your child gave us information without your permission, email $_supportEmail and we will delete it.",
                      ),
                    ],
                  ),
                  _PolicySection(
                    title: '9. Information Stored Outside Trinidad & Tobago',
                    paragraphs: [
                      _PolicyText(
                        text:
                            'The services we rely on are based outside Trinidad & Tobago and may store your information in the United States, the European Union, or elsewhere. By using Aturservicett, you agree to this transfer. We require our providers to maintain security and privacy protections consistent with the T&T Data Protection Act 2011.',
                      ),
                    ],
                  ),
                  _PolicySection(
                    title: '10. Changes To This Policy',
                    paragraphs: [
                      _PolicyText(
                        text:
                            'If we make important changes to this policy, we will notify you in the app or by email. The latest version will always be available in the app.',
                      ),
                    ],
                  ),
                  _PolicySection(
                    title: '11. How To Contact Us',
                    paragraphs: [
                      _PolicyText(
                        label: 'Aturservicett LLC',
                        text: '- [REGISTERED ADDRESS] - $_supportEmail',
                      ),
                      _PolicyText(
                        text:
                            'You can also lodge a complaint with the Office of the Information Commissioner of Trinidad & Tobago if you believe we have mishandled your information.',
                      ),
                    ],
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

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return _PolicyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TitleText('The Short Version'),
          SizedBox(height: 10),
          _BodyText(
            'Aturservicett LLC ("we") runs the Aturservicett app. This policy explains what personal information we collect, why we collect it, what we do with it, and the rights you have over it. If you have any questions, email us at support@aturservicett.com.',
          ),
          SizedBox(height: 12),
          _SectionMiniTitle('The essentials at a glance'),
          SizedBox(height: 8),
          _BulletList(
            bullets: [
              'We collect only what we need to run the app: email, name, area, and for tradesmen, trade details, rate, phone number, and photos.',
              'We do not sell your data. Ever.',
              'We do not send marketing emails.',
              'We do not track your GPS location.',
              'We do not read your WhatsApp messages. Those happen outside our app.',
              'You can access, correct, or delete your data at any time.',
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({
    required this.title,
    this.intro,
    this.paragraphs = const [],
    this.bullets = const [],
    this.footer,
  });

  final String title;
  final String? intro;
  final List<_PolicyText> paragraphs;
  final List<String> bullets;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _PolicyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleText(title),
            if (intro != null) ...[
              const SizedBox(height: 9),
              _BodyText(intro!),
            ],
            if (paragraphs.isNotEmpty) ...[
              const SizedBox(height: 9),
              ...paragraphs.map(
                (paragraph) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: paragraph,
                ),
              ),
            ],
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 9),
              _BulletList(bullets: bullets),
            ],
            if (footer != null) ...[
              const SizedBox(height: 9),
              _BodyText(footer!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ThirdPartySection extends StatelessWidget {
  const _ThirdPartySection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _PolicyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _TitleText('4. Who Sees Your Information'),
            SizedBox(height: 9),
            _BodyText(
              'Other users can see your first name and last initial. If you are a tradesman, they can also see your trade, area, rate, bio, photos, and reviews. Your email address is never shown to other users. Your phone number is shared with a client only at the moment they tap the WhatsApp button to message you.',
            ),
            SizedBox(height: 12),
            _SectionMiniTitle('These third-party services help us run the app'),
            SizedBox(height: 10),
            _ServiceTable(),
            SizedBox(height: 10),
            _BodyText(
              'We may share information with law enforcement when required by a lawful order, to comply with T&T law, or to protect the safety of users.',
            ),
            SizedBox(height: 8),
            _BodyText('We never sell or rent your personal information.'),
          ],
        ),
      ),
    );
  }
}

class _ServiceTable extends StatelessWidget {
  const _ServiceTable();

  static const _rows = [
    ('Resend', 'Sends email verification codes and essential account emails.'),
    ('Supabase', 'Stores account, profile, and review data securely.'),
    (
      'WhatsApp (Meta)',
      'Handles client-to-tradesman conversations after the hand-off. WhatsApp policies apply to those messages.',
    ),
    ('Google AdSense', 'Shows advertisements in limited parts of the app.'),
    (
      'Apple / Google',
      'Distribute the app through their app stores under their own policies.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TermsAndPrivacyScreen._borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const _ServiceRow(
            service: 'Service',
            details: 'What they handle',
            isHeader: true,
          ),
          ..._rows.map((row) => _ServiceRow(service: row.$1, details: row.$2)),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.details,
    this.isHeader = false,
  });

  final String service;
  final String details;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.outfit(
      color: isHeader
          ? TermsAndPrivacyScreen._darkText
          : TermsAndPrivacyScreen._mutedText,
      fontSize: 11,
      fontWeight: isHeader ? FontWeight.w800 : FontWeight.w500,
      height: 1.35,
    );

    return Container(
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFFF7E9DC) : Colors.transparent,
        border: Border(
          top: BorderSide(
            color: isHeader
                ? Colors.transparent
                : TermsAndPrivacyScreen._borderColor,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 104, child: Text(service, style: textStyle)),
          const SizedBox(width: 10),
          Expanded(child: Text(details, style: textStyle)),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TermsAndPrivacyScreen._cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TermsAndPrivacyScreen._borderColor),
      ),
      child: child,
    );
  }
}

class _PolicyText extends StatelessWidget {
  const _PolicyText({this.label, required this.text});

  final String? label;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (label == null) return _BodyText(text);

    return RichText(
      text: TextSpan(
        style: GoogleFonts.outfit(
          color: TermsAndPrivacyScreen._mutedText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              color: TermsAndPrivacyScreen._darkText,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.bullets});

  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bullets
          .map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '-',
                    style: GoogleFonts.outfit(
                      color: TermsAndPrivacyScreen._headerColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _BodyText(bullet)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: TermsAndPrivacyScreen._darkText,
        fontSize: 16,
        fontWeight: FontWeight.w900,
        height: 1.2,
      ),
    );
  }
}

class _SectionMiniTitle extends StatelessWidget {
  const _SectionMiniTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: TermsAndPrivacyScreen._headerColor,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        height: 1.25,
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: TermsAndPrivacyScreen._mutedText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.45,
      ),
    );
  }
}
