import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/client_profile/screens/edit_profile_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _headerColor = Color(0xFFBC4437);
  static const _cardColor = Color(0xFFFFFCF8);
  static const _borderColor = Color(0xFFD3C7BD);
  static const _darkText = Color(0xFF221C18);
  static const _mutedText = Color(0xFF84796F);
  static const _goldColor = Color(0xFFF6C451);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          const _ProfileHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 22, 12, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SectionLabel('ACCOUNT INFO'),
                  SizedBox(height: 8),
                  _ProfileMenuItem(
                    showChevron: false,
                    icon: Icons.person,
                    iconColor: Color(0xFF6D95AC),
                    label: 'NAME',
                    value: 'Keisha P.',
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 8),
                  _ProfileMenuItem(
                    showChevron: false,
                    icon: Icons.phone_iphone,
                    iconColor: Color(0xFF1F272C),
                    label: 'PHONE',
                    value: '+1 868 754-2288',
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 8),
                  _ProfileMenuItem(
                    showChevron: false,
                    icon: Icons.location_on,
                    iconColor: Color(0xFFE05249),
                    label: 'AREA',
                    value: 'Chaguanas',
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  _SectionLabel('HELP & SUPPORT'),
                  SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.question_mark,
                    iconColor: Color(0xFFFF3D32),
                    backgroundColor: Colors.white,
                    value: 'Help & FAQ',
                  ),
                  SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.info,
                    iconColor: Color(0xFF5A7E99),
                    backgroundColor: Colors.white,
                    value: 'About Aturservicett',
                  ),
                  SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.article,
                    iconColor: Color(0xFFA87A4C),
                    backgroundColor: Colors.white,
                    value: 'Terms & Privacy',
                  ),
                  SizedBox(height: 20),
                  _SectionLabel('ACCOUNT'),
                  SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.logout,
                    iconColor: _headerColor,
                    value: 'Sign out',
                    valueColor: _headerColor,
                    backgroundColor: Color(0xFFFFF3F1),
                    borderColor: Color(0xFFEABCB5),
                    showChevron: false,
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ProfileScreen._headerColor,
      padding: const EdgeInsets.only(top: 60, left: 18, right: 18, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HeaderPillButton(
                label: 'Back',
                icon: Icons.arrow_back,
                onTap: () => Get.back(),
              ),
              _HeaderPillButton(
                label: 'Edit',
                onTap: () => Get.to(() => const EditProfileScreen()),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ProfileScreen._goldColor,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFDA78), width: 4),
            ),
            child: Text(
              'K',
              style: GoogleFonts.outfit(
                color: ProfileScreen._darkText,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keisha P.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Chaguanas, Trinidad',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'MEMBER SINCE NOV 2026',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPillButton extends StatelessWidget {
  const _HeaderPillButton({
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .18),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.fromLTRB(icon == null ? 12 : 8, 6, 12, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: Colors.white),
                const SizedBox(width: 3),
              ],
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
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
        color: ProfileScreen._mutedText,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    this.label,
    this.valueColor,
    this.backgroundColor = ProfileScreen._cardColor,
    this.borderColor = ProfileScreen._borderColor,
    this.showChevron = true,
  });

  final IconData icon;
  final Color iconColor;
  final String? label;
  final String value;
  final Color? valueColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 65,
          //constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
            //color: Colors.white
          ),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFe8e3f3),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (label != null) ...[
                      Text(
                        label!,
                        style: GoogleFonts.outfit(
                          color: ProfileScreen._mutedText,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                    ],
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: valueColor ?? ProfileScreen._darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              if (showChevron)
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFFB9A693),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
