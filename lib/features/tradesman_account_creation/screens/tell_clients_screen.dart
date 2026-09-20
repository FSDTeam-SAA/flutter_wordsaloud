import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aturservicett/core/widgets/button_widget.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tell_clients_controller.dart';

class TellClientsScreen extends StatelessWidget {
  const TellClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TellClientsController());

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
                'Step 3 of 3',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Title
              Text(
                'Tell clients about yourself.',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Keep it real. 140 chars.',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF1E1E1E),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),

              // Pitch label
              Obx(
                () => Text(
                  'Pitch ${controller.pitch.value.length}/140',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Pitch TextField
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      maxLength: 140,
                      maxLines: 4,
                      onChanged: controller.onPitchChanged,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText:
                            'WASA-certified plumber. MIC -certified (12 yrs residential. Leaks, pumps, bathroom installs.)',
                        hintStyle: GoogleFonts.outfit(
                          color: const Color(0xFF6D6D6D),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFEF8F3),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    if (controller.pitchError.value.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        controller.pitchError.value,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: const Color(0xFFA83F2D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Typical Rate label
              Text(
                'Typical Rate',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),

              // TT$ + Rate Input + Unit Dropdown
              Row(
                children: [
                  // TT$ prefix
                  Text(
                    'TT\$',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF454545),
                    ),
                  ),
                  SizedBox(width: 11),
                  // Rate input
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: controller.onRateChanged,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: '450',
                        hintStyle: GoogleFonts.outfit(
                          color: const Color(0xFF6D6D6D),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF5EFE6),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 11),
                  // Per day dropdown
                  Obx(
                    () => Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5EFE6),
                          border: Border.all(
                            color: const Color(0xFFA83F2D),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.rateUnit.value,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            items: controller.rateUnits
                                .map(
                                  (unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(
                                      unit,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                controller.selectRateUnit(val);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => controller.rateError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          controller.rateError.value,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: const Color(0xFFA83F2D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 28),

              // Add work photos label
              Text(
                'Add work photos',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),

              // Photo picker area
              Obx(() {
                if (controller.workPhotos.isEmpty) {
                  return GestureDetector(
                    onTap: controller.pickPhotos,
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1814),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF3A3A3A),
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.upload_file_outlined,
                            color: Colors.white54,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Drop your files here',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: controller.pickPhotos,
                            child: Text(
                              'Choose File',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.workPhotos.length + 1,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            if (index == controller.workPhotos.length) {
                              return GestureDetector(
                                onTap: controller.pickPhotos,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1814),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white54,
                                    size: 30,
                                  ),
                                ),
                              );
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(controller.workPhotos[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              }),
              const SizedBox(height: 10),
              Text(
                'A starting rate. You\'ll still quote jobs.',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF6D6D6D),
                ),
              ),
              const SizedBox(height: 50),

              // Continue button
              Obx(
                () => Column(
                  children: [
                    if (controller.apiError.value.isNotEmpty) ...[
                      Text(
                        controller.apiError.value,
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
                            onPressed: controller.onContinuePressed,
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
