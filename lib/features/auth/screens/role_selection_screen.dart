import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';
import 'package:flutter_wordsaloud/features/auth/controller/role_selection_controller.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  late final RoleSelectionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RoleSelectionController(), permanent: true);
    controller.loadOfferNoteVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Creamy background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Logo & Text
                    Image.asset(
                      'assets/images/Frame 2147234823.png',
                      height: 36,
                      width: 203,
                    ),
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
                    Obx(
                      () => controller.showOfferNote.value
                          ? const Column(
                              children: [
                                _TradesmanOfferNote(),
                                SizedBox(height: 14),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Role 1: I need a tradesman
                    Obx(
                      () => RoleCard(
                        isSelected: controller.selectedRole.value == 0,
                        onTap: () => controller.selectRole(0),
                        backgroundColor: const Color(0xFF1C1814),
                        title: 'I need a tradesman',
                        subtitle: 'Find skilled workers in T n T',
                        description:
                            'Browse, message, hire. Real reviews from real Trinis.Free to join.',
                        image: 'assets/images/material-symbols_person (1).png',
                        contentColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Role 2: I am a tradesman
                    Obx(
                      () => RoleCard(
                        isSelected: controller.selectedRole.value == 1,
                        onTap: () => controller.selectRole(1),
                        backgroundColor: const Color(0xFFF5C77A),
                        title: 'I am a tradesman',
                        subtitle: 'List your skills, get hired',
                        description: 'Free to join.',
                        image: 'assets/images/project-manager_8741633 1.png',
                        contentColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 38),

                    // Continue Button
                    Center(
                      child: Obx(
                        () => CustomButton(
                          text: 'Continue',
                          icon: Icons.arrow_forward,
                          onPressed: controller.selectedRole.value != null
                              ? controller.onContinue
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TradesmanOfferNote extends StatelessWidget {
  const _TradesmanOfferNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      // decoration: BoxDecoration(
      //   color: const Color(0xFFFFF8EF),
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: const Color(0xFFE7B75C), width: 1.2),
      // ),
      // child: Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Container(
      //       width: 28,
      //       height: 28,
      //       decoration: const BoxDecoration(
      //         color: Color(0xFFF5B84B),
      //         shape: BoxShape.circle,
      //       ),
      //       alignment: Alignment.center,
      //       child: const Icon(Icons.info, size: 18, color: Color(0xFF5D4315)),
      //     ),
      //     const SizedBox(width: 10),
      //     Expanded(
      //       child: RichText(
      //         text: TextSpan(
      //           style: GoogleFonts.outfit(
      //             fontSize: 12,
      //             fontWeight: FontWeight.w500,
      //             color: const Color(0xFF5F574F),
      //             height: 1.25,
      //           ),
      //           children: [
      //             TextSpan(
      //               text: 'Might offer your services one day?\n',
      //               style: GoogleFonts.outfit(
      //                 fontSize: 14,
      //                 fontWeight: FontWeight.w800,
      //                 color: const Color(0xFF3F3832),
      //                 height: 1.15,
      //               ),
      //             ),
      //             const TextSpan(text: 'Sign up as a '),
      //             TextSpan(
      //               text: 'tradesman',
      //               style: GoogleFonts.outfit(
      //                 fontSize: 12,
      //                 fontWeight: FontWeight.w800,
      //                 color: const Color(0xFFA83F2D),
      //                 height: 1.25,
      //               ),
      //             ),
      //             const TextSpan(
      //               text:
      //                   ' - one email can only hold one role, but tradesman accounts can also browse and hire.',
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
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
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFFA83F2D), width: 3)
              : Border.all(color: Colors.transparent, width: 3),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFA83F2D).withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Column(
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
                        child: Image.asset(image, width: 34, height: 34),
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
                    const SizedBox(width: 34),
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
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA83F2D),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check, size: 15, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
