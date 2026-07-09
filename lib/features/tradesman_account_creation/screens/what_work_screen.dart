import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/what_work_controller.dart';

class WhatWorkScreen extends StatelessWidget {
  const WhatWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WhatWorkController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
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
                'Step 2 of 3',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF6D6D6D),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Title
              Text(
                'What can you work?',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Home base + how far you\'ll travel.',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF1E1E1E),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),

              // Home Area Label
              Text(
                'Home Area',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),

              // Home Area Input
              TextField(
                onChanged: (v) => controller.homeArea.value = v,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'San Fernando',
                  hintStyle: GoogleFonts.outfit(
                    color: const Color(0xFF6D6D6D),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Color(0xFFFEF8F3),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFFA83F2D), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFFA83F2D), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFFA83F2D), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Travel Range Label
              Text(
                'Travel Range',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),

              // Travel Range Options
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.travelRanges.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final range = controller.travelRanges[index];
                    return Obx(() {
                      final isSelected = controller.selectedRange.value == index;
                      return GestureDetector(
                        onTap: () => controller.selectRange(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Color(0xFFFEF8F3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFC34D3C)
                                  : const Color(0xFFCDCDCD),
                              width: isSelected ? 1: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Text block
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      range['title']!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF454545),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      range['subtitle']!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF6D6D6D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Radio indicator
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? const Color(0xFFA83F2D)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFA83F2D)
                                        : Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),

              // Bottom Continue Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 12),
                child: CustomButton(
                  text: 'Continue',
                  onPressed: controller.onContinuePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
