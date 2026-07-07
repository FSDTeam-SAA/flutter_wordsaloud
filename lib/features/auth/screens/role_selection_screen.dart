import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';
import 'package:flutter_wordsaloud/features/auth/controller/role_selection_controller.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoleSelectionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Creamy background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Logo & Text
              Image.asset('assets/images/Frame 2147234823.png', height: 36, width: 203,),
              const SizedBox(height: 43),

              // Welcome Text
              Text(
                'Welcome.',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                  children: const [
                    TextSpan(text: "Let's get you "),
                    TextSpan(
                      text: 'sorted',
                      style: TextStyle(color: Color(0xFFA83F2D)),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tell us what brings you here.',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),

              // Roles
              Expanded(
                child: Column(
                  children: [
                    // Role 1: I need a tradesman
                    Obx(() => RoleCard(
                          isSelected: controller.selectedRole.value == 0,
                          onTap: () => controller.selectRole(0),
                          backgroundColor: const Color(0xFF1C1814),
                          title: 'I need a tradesman',
                          subtitle: 'Find skilled workers in T n T',
                          description:
                              'Browse, message, hire. Real reviews from real Trinis.',
                          image: 'assets/images/material-symbols_person (1).png',
                          contentColor: Colors.white,
                        )),
                    const SizedBox(height: 16),

                    // Role 2: I am a tradesman
                    Obx(() => RoleCard(
                          isSelected: controller.selectedRole.value == 1,
                          onTap: () => controller.selectRole(1),
                          backgroundColor: const Color(0xFFF5C77A),
                          title: 'I am a tradesman',
                          subtitle: 'List your skills, get hired',
                          description: 'Free to join.',
                          image: 'assets/images/project-manager_8741633 1.png',
                          contentColor: Colors.black,
                        )),
                  ],
                ),
              ),

              // Continue Button
              Center(
                child: Obx(() => CustomButton(
                      text: 'Continue',
                      icon: Icons.arrow_forward,
                      onPressed: controller.selectedRole.value != null
                          ? controller.onContinue
                          : null,
                    )),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final Color contentColor;

  const RoleCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFFA83F2D), width: 1)
              : Border.all(color: Colors.transparent, width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar/Icon Circle
                Container(

                  decoration: const BoxDecoration(
                    color: Color(0xFF9E3A24), // Circle color from image
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset(image, width: 34, height: 34,),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: contentColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: contentColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: contentColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
