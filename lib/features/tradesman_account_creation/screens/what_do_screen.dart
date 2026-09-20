import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aturservicett/core/widgets/button_widget.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/what_do_controller.dart';

class WhatDoScreen extends StatelessWidget {
  const WhatDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WhatDoController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Creamy background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Center(
              child: Text(
                'Step 1 of 3',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF737373),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header
              Text(
                'What can you do?',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap your main first, then two extras.',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF1E1E1E),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Summary bar
              Obx(() {
                final count = controller.totalSelectedCount;
                final mainName = controller.mainSkillName;
                return Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBD7C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$count selected',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFC54D3C),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: mainName.isNotEmpty ? mainName : 'None',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: ' in main',
                              style: TextStyle(color: Color(0xFF6D6D6D)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Skill selection grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemCount: controller.skills.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final skill = controller.skills[index];

                    return Obx(() {
                      final isSelected = controller.isSelected(index);
                      final isMain = controller.isMain(index);

                      // Card styling details
                      final Color cardBgColor = isMain
                          ? const Color(0xFFA83F2D)
                          : Colors.white;

                      final Border cardBorder = isMain
                          ? Border.all(color: Colors.transparent)
                          : isSelected
                          ? Border.all(
                              color: const Color(0xFFA83F2D),
                              width: 1.5,
                            )
                          : Border.all(
                              color: const Color(0xFFCDCDCD),
                              width: 1,
                            );

                      final Color itemColor = isMain
                          ? Colors.white
                          : isSelected
                          ? Colors.black
                          : const Color(0xFF6D6D6D);

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () => controller.toggleSkill(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                borderRadius: BorderRadius.circular(8),
                                border: cardBorder,
                                boxShadow: [
                                  if (!isMain)
                                    BoxShadow(
                                      color: const Color(0x05000000),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      skill.image,
                                      width: 24,
                                      height: 24,
                                      //color: isMain ? const Color(0xFFEBD7C7) : const Color(0xFF6D6D6D),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        skill.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: itemColor,
                                        ),
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: isMain
                                              ? const Color(0xFFE29A32)
                                              : const Color(0xFFA83F2D),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Badges overlay
                          if (isMain)
                            Positioned(
                              top: -8,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAAE4B),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'MAIN',
                                  style: GoogleFonts.outfit(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (skill.isNew)
                            Positioned(
                              top: -8,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF276A78),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'NEW',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    });
                  },
                ),
              ),

              // Bottom Button
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                  child: Obx(
                    () => Column(
                      children: [
                        if (controller.errorMessage.value.isNotEmpty) ...[
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: const Color(0xFFA83F2D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        controller.isLoading.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFA83F2D),
                                ),
                              )
                            : CustomButton(
                                text: 'Continue',
                                icon: Icons.arrow_forward,
                                onPressed:
                                    controller.selectMainIndex.value != null
                                    ? controller.onContinuePressed
                                    : null,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
