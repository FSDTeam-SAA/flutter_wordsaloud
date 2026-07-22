import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/client_profile/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

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
            text1: 'Terms & ',
            text2: 'Conditions',
            suvbtitle: 'The rules for using Aturservicett',
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
                  _TermsSection(
                    title: '1. Who Can Use Aturservicett',
                    paragraphs: [
                      _TermsText(
                        label: 'Clients:',
                        text:
                            "You must be at least 13 years old. If you are under 18, we assume you have your parent's or guardian's permission.",
                      ),
                      _TermsText(
                        label: 'Tradesmen:',
                        text:
                            'You must be at least 18 years old to list your services.',
                      ),
                      _TermsText(
                        text:
                            'You need to give us accurate information about yourself and keep it up to date. You can only have one account.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '2. What Aturservicett Is And Is Not',
                    paragraphs: [
                      _TermsText(
                        label: 'Aturservicett is a directory.',
                        text:
                            'We help clients find skilled tradesmen and read real reviews. We show profiles, ratings, and a WhatsApp button so you can message tradesmen directly.',
                      ),
                      _TermsText(
                        label: 'Aturservicett is not a middleman.',
                        text:
                            'We do not employ tradesmen, do not handle payments, and do not guarantee any work. Everything you agree with a tradesman, including price, quality, timing, and safety, is strictly between the two of you.',
                      ),
                      _TermsText(
                        text:
                            'The "Verified" badge means we checked a tradesman\'s registration when they signed up. It does not mean we have verified their licenses, insurance, or ongoing quality. Always check credentials yourself before hiring.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '3. If You Are A Tradesman',
                    intro: 'You promise us that:',
                    bullets: [
                      'You are at least 18 years old.',
                      'The information on your profile, including trades, area, rate, bio, and photos, is true and current.',
                      'You have all the licenses, insurance, and permits your trade requires in Trinidad & Tobago.',
                      'You will do any work you agree to in a professional way and follow all applicable laws.',
                      'Photos on your profile are of your own work or used with permission.',
                    ],
                    footer:
                        'You are the one running your business. You set your rates, take your payments, handle your disputes, and pay your own taxes. Aturservicett is not your employer, agent, or business partner.',
                  ),
                  _TermsSection(
                    title: '4. If You Are A Client',
                    paragraphs: [
                      _TermsText(
                        text:
                            'You agree to check tradesmen carefully before hiring. Read reviews, ask for credentials, and agree on the work in writing before starting. Aturservicett gives you information to help you decide, but the choice of who to hire is yours.',
                      ),
                      _TermsText(
                        text:
                            'You pay tradesmen directly, using whatever method the two of you agree on. Aturservicett never touches your money.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '5. Reviews',
                    intro:
                        'Reviews must reflect your real, first-hand experience. You agree not to:',
                    bullets: [
                      'Post reviews for work you did not actually engage.',
                      'Post reviews in exchange for payment or discounts from the tradesman.',
                      'Post reviews of yourself, your own business, or a competitor.',
                      'Post reviews with false claims, insults, personal information, or discriminatory language.',
                    ],
                    footer:
                        'We may remove reviews that break these rules. If you spot a fake or abusive review, tell us at $_supportEmail.',
                  ),
                  _TermsSection(
                    title: '6. Things You Must Not Do',
                    intro: 'Do not use Aturservicett to:',
                    bullets: [
                      'Break any law or engage in fraud.',
                      'Pretend to be someone else.',
                      'Access another user\'s account or private information.',
                      'Damage, disrupt, or hack the app.',
                      'Scrape data from the app or copy our content.',
                      'Send spam or unsolicited marketing to other users.',
                      'Post anything abusive, threatening, discriminatory, or that infringes someone else\'s rights.',
                    ],
                    footer:
                        'If you break these rules, we may suspend or delete your account, remove your content, and, if serious, refer the matter to Trinidad & Tobago authorities.',
                  ),
                  _TermsSection(
                    title: '7. Advertising And Paid Features',
                    paragraphs: [
                      _TermsText(
                        label: 'VIP Featured Listings:',
                        text:
                            'Tradesmen can pay for enhanced visibility, shown with a "VIP" badge. VIP status is billed separately, non-refundable once active, and does not exempt anyone from these Terms.',
                      ),
                      _TermsText(
                        label: 'Third-party ads:',
                        text:
                            'The app may display ads from Google AdSense or other partners. We do not endorse these ads. Interactions with them are governed by the advertiser\'s own policies.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '8. Intellectual Property',
                    paragraphs: [
                      _TermsText(
                        text:
                            'The Aturservicett name, logo, app design, and content we create are owned by Aturservicett LLC. You may not copy or reuse them without our permission.',
                      ),
                      _TermsText(
                        text:
                            'You own the reviews, photos, and profile content you post. When you post something, you give us permission to display it in the app and use it to promote Aturservicett. You can ask us to remove your content at any time by emailing $_supportEmail.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '9. Our Liability',
                    paragraphs: [
                      _TermsText(
                        label: 'The app is provided "as is".',
                        text:
                            'We do our best to keep it working, but we do not guarantee it will always be available or error-free.',
                      ),
                      _TermsText(
                        label:
                            'We are not responsible for what happens between clients and tradesmen.',
                        text:
                            'If a tradesman does poor work, damages your property, or does not show up, that dispute is between you and the tradesman. Aturservicett is not liable for it.',
                      ),
                      _TermsText(
                        text:
                            'To the fullest extent allowed by law, our total liability to you for any claim relating to the app is limited to the greater of TT\$100 or what you have paid us in the last twelve months.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '10. Ending Your Account',
                    paragraphs: [
                      _TermsText(
                        text:
                            'You can delete your account any time by emailing $_supportEmail.',
                      ),
                      _TermsText(
                        text:
                            'We can suspend or delete your account if you break these Terms, harm other users, or the law requires us to.',
                      ),
                      _TermsText(
                        text:
                            'When your account ends, we may still keep some records where the law requires. See our Privacy Policy for details on data retention.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '11. Changes To These Terms',
                    paragraphs: [
                      _TermsText(
                        text:
                            'We may update these Terms from time to time. If the changes are important, we will let you know through the app or by email. If you keep using the app after changes take effect, that means you accept the updated Terms.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '12. Law And Disputes',
                    paragraphs: [
                      _TermsText(
                        text:
                            'These Terms are governed by the laws of the Republic of Trinidad & Tobago. If you have a complaint, please email us first at $_supportEmail. We will try to resolve it within 30 days. If we cannot, any dispute will be handled by the courts of Trinidad & Tobago.',
                      ),
                    ],
                  ),
                  _TermsSection(
                    title: '13. How To Contact Us',
                    paragraphs: [
                      _TermsText(
                        label: 'Aturservicett LLC',
                        text: '- [REGISTERED ADDRESS] - $_supportEmail',
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
    return _TermsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TitleText('Welcome To Aturservicett'),
          SizedBox(height: 10),
          _BodyText(
            'These are the rules for using the Aturservicett app. When you sign up, browse, contact a tradesman, or leave a review, you agree to these Terms. Aturservicett is operated by Aturservicett LLC, a company registered in the Republic of Trinidad & Tobago at [REGISTERED ADDRESS].',
          ),
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({
    required this.title,
    this.intro,
    this.paragraphs = const [],
    this.bullets = const [],
    this.footer,
  });

  final String title;
  final String? intro;
  final List<_TermsText> paragraphs;
  final List<String> bullets;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _TermsCard(
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

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TermsAndConditionScreen._cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TermsAndConditionScreen._borderColor),
      ),
      child: child,
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText({this.label, required this.text});

  final String? label;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (label == null) return _BodyText(text);

    return RichText(
      text: TextSpan(
        style: GoogleFonts.outfit(
          color: TermsAndConditionScreen._mutedText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              color: TermsAndConditionScreen._darkText,
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
                      color: TermsAndConditionScreen._headerColor,
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
        color: TermsAndConditionScreen._darkText,
        fontSize: 16,
        fontWeight: FontWeight.w900,
        height: 1.2,
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
        color: TermsAndConditionScreen._mutedText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.45,
      ),
    );
  }
}
