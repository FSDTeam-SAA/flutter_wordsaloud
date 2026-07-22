import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';

class YouAreLiveScreen extends StatelessWidget {
  final String tradesmanName;
  final String tradesmanSkill;
  final String homeArea;
  final String? profileImagePath;

  const YouAreLiveScreen({
    super.key,
    this.tradesmanName = 'Tradesman',
    this.tradesmanSkill = '',
    this.homeArea = '',
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TradesmanController>();
    final profileSubtitle = [
      tradesmanSkill.trim(),
      homeArea.trim(),
    ].where((value) => value.isNotEmpty).join(' • ');

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Gold checkmark circle
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAAE4B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 42),
              ),
              const SizedBox(height: 28),

              // "You're live!" title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  children: const [
                    TextSpan(text: "You're "),
                    TextSpan(
                      text: 'live!',
                      style: TextStyle(color: Color(0xFFEAAE4B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Your profile is now visible to clients in\nTrinidad and Tobago',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF62748E),
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Profile card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A241E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF3E5CF), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: Color(0xFFA83F2D),
                            shape: BoxShape.circle,
                          ),
                          child:
                              profileImagePath != null &&
                                  profileImagePath!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(26),
                                  child: Image.file(
                                    File(profileImagePath!),
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 28,
                                ),
                        ),
                        const SizedBox(width: 14),
                        // Name & sub-label
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tradesmanName,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profileSubtitle.isNotEmpty
                                    ? profileSubtitle
                                    : 'Find skilled workers nearby',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              SizedBox(height: 11),
                              // Pending Verification badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C5D4A),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Pending Verification',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFEAAE4B),
                                  ),
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

              const Spacer(flex: 3),

              // Go to dashboard button
              Obx(
                () => Column(
                  children: [
                    if (controller.errorMessage.value.isNotEmpty) ...[
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: const Color(0xFFEAAE4B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    controller.isLoading.value
                        ? const SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFEAAE4B),
                              ),
                            ),
                          )
                        : CustomButton(
                      backgroundColor: Color(0xFFE5A742),
                            textColor: Colors.black,
                            height: 50,
                            borderRadius: 16,
                            text: 'Go to dashboard',
                            onPressed: () async {
                              await controller.goLive(
                                tradesmanName: tradesmanName,
                                tradesmanSkill: tradesmanSkill,
                                homeArea: homeArea,
                                profileImagePath: profileImagePath,
                              );
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
