import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/features/home/controller/edit_profile_controller.dart';

class TradesmanEditProfileScreen extends StatefulWidget {
  final String tradesmanName;
  final String tradesmanPhone;
  final String tradesmanSkill;
  final String homeArea;
  final String? profileImagePath;

  const TradesmanEditProfileScreen({
    super.key,
    required this.tradesmanName,
    required this.tradesmanPhone,
    required this.tradesmanSkill,
    required this.homeArea,
    this.profileImagePath,
  });

  @override
  State<TradesmanEditProfileScreen> createState() => _TradesmanEditProfileScreenState();
}

class _TradesmanEditProfileScreenState extends State<TradesmanEditProfileScreen> {
  String _getTradeImage(String tradeName) {
    switch (tradeName.toLowerCase().trim()) {
      case 'phone tech':
        return 'assets/images/fi_5060325.png';
      case 'computer tech':
        return 'assets/images/fi_10528057.png';
      case 'plumber':
        return 'assets/images/fi_6342703.png';
      case 'electrician':
        return 'assets/images/fi_9781304.png';
      case 'carpenter':
        return 'assets/images/fi_12479483.png';
      case 'joinery':
        return 'assets/images/fi_14106303.png';
      case 'mobile mech':
        return 'assets/images/fi_186239.png';
      case 'painter':
        return 'assets/images/fi_1995467.png';
      case 'appliance':
        return 'assets/images/fi_2012957.png';
      case 'ac tech':
        return 'assets/images/fi_7969720.png';
      case 'tile man':
        return 'assets/images/fi_11932525.png';
      case 'mason':
        return 'assets/images/fi_18029670.png';
      case 'glass man':
        return 'assets/images/fi_896123.png';
      case 'roofer':
        return 'assets/images/fi_14620736.png';
      case 'welder/gate':
        return 'assets/images/fi_9439147.png';
      case 'pool cleaner':
        return 'assets/images/fi_15551378.png';
      case 'tree cutter':
        return 'assets/images/fi_6327310.png';
      case 'landscaper':
        return 'assets/images/fi_10033506.png';
      case 'auto body':
        return 'assets/images/fi_6332022.png';
      case 'contractor':
        return 'assets/images/fi_4490380.png';
      default:
        return 'assets/images/fi_5060325.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Instantiate/initialize the controller with passed-in values
    final EditProfileController controller = Get.put(
      EditProfileController(
        initialName: widget.tradesmanName,
        initialPhone: widget.tradesmanPhone,
        initialMainTrade: widget.tradesmanSkill,
        initialHomeArea: widget.homeArea,
        initialProfileImagePath: widget.profileImagePath,
        initialPitch: 'WASA-certified plumber. 12 yrs residential. Leaks, pumps, bathroom installs.',
        initialRate: '350',
        initialRateUnit: 'per day',
        initialExtraTrades: const ['Carpenter', 'Tile Man'],
      ),
    );

    final TextEditingController bioTextController =
    TextEditingController(text: controller.pitch.value);
    final TextEditingController rateTextController =
    TextEditingController(text: controller.rate.value);
    final TextEditingController homeAreaTextController =
    TextEditingController(text: controller.homeArea.value);

    // Sync input fields back to controller
    bioTextController.addListener(() {
      controller.pitch.value = bioTextController.text;
    });
    rateTextController.addListener(() {
      controller.rate.value = rateTextController.text;
    });
    homeAreaTextController.addListener(() {
      controller.homeArea.value = homeAreaTextController.text;
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Cream background
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Change Photo Header Section
                    Row(
                      children: [
                        // Avatar block with edit button
                        Obx(() {
                          final path = controller.profileImagePath.value;
                          return Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA83F2D),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: path != null && path.isNotEmpty
                                    ? GestureDetector(
                                  onTap: controller.pickProfilePhoto,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      File(path),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                    : Center(
                                  child: Text(
                                    widget.tradesmanName.isNotEmpty
                                        ? (widget.tradesmanName[0] +
                                        (widget.tradesmanName.contains(' ')
                                            ? widget.tradesmanName.split(' ')[1][0]
                                            : ''))
                                        .toUpperCase()
                                        : 'TR',
                                    style: GoogleFonts.outfit(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: InkWell(
                                  onTap: controller.pickProfilePhoto,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEAAE4B),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: controller.pickProfilePhoto,
                                child: Text(
                                  'Change photo',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFA83F2D),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'A clear headshot helps clients recognize you.',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF6D6D6D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEBD7C7), thickness: 1),
                    const SizedBox(height: 16),

                    // 2. Your Pitch (Bio) Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('YOUR PITCH (BIO)'),
                        Obx(() => Text(
                          '${controller.pitch.value.length} / 140',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: const Color(0xFF6D6D6D),
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: bioTextController,
                      maxLines: 3,
                      maxLength: 140,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.6,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 3. Typical Rate Section
                    _buildSectionHeader('TYPICAL RATE'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Currency badge
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBD7C7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'TT\$',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Number field
                        Expanded(
                          child: TextField(
                            controller: rateTextController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFA83F2D),
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFA83F2D),
                                  width: 1.6,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Unit dropdown
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFEBD7C7),
                              width: 1.5,
                            ),
                          ),
                          child: Obx(() => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.rateUnit.value,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.rateUnit.value = newValue;
                                }
                              },
                              items: <String>['per day', 'per hour', 'per job']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 4. Your Trades Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('YOUR TRADES'),
                        Text(
                          'Main trade + extras',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: const Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final main = controller.mainTrade.value;
                      final extras = controller.extraTrades;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: [
                          if (main.isNotEmpty)
                            _buildTradeChip(
                              name: '$main - MAIN',
                              imagePath: _getTradeImage(main),
                              isMain: true,
                              onDelete: () => controller.removeTrade(main),
                            ),
                          ...extras.map((trade) => _buildTradeChip(
                            name: trade,
                            imagePath: _getTradeImage(trade),
                            isMain: false,
                            onDelete: () => controller.removeTrade(trade),
                          )),
                          if (controller.remainingTrades.isNotEmpty)
                            InkWell(
                              onTap: () => _showAddTradeDialog(context, controller),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF8D7766),
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Color(0xFF6D6D6D),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Add trade',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF6D6D6D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),

                    // 5. Home Area Section
                    _buildSectionHeader('HOME AREA'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: homeAreaTextController,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFA83F2D),
                            width: 1.6,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 6. Travel Range Section
                    _buildSectionHeader('TRAVEL RANGE'),
                    const SizedBox(height: 8),
                    Obx(() => Column(
                      children: [
                        _buildTravelRangeTile(
                          title: '5 km - Local only',
                          subtitle: 'My immediate area',
                          isSelected: controller.travelRange.value == '5 km - Local only',
                          onTap: () => controller.travelRange.value = '5 km - Local only',
                        ),
                        const SizedBox(height: 8),
                        _buildTravelRangeTile(
                          title: 'Trinidad-wide',
                          subtitle: 'Anywhere in Trinidad',
                          isSelected: controller.travelRange.value == 'Trinidad-wide',
                          onTap: () => controller.travelRange.value = 'Trinidad-wide',
                        ),
                        const SizedBox(height: 8),
                        _buildTravelRangeTile(
                          title: 'T&T-wide',
                          subtitle: 'Both islands - ferry/flight',
                          isSelected: controller.travelRange.value == 'T&T-wide',
                          onTap: () => controller.travelRange.value = 'T&T-wide',
                        ),
                      ],
                    )),

                    const SizedBox(height: 24),

                    // 7. Contact details are locked Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF1EB), // Light tinted backdrop
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFF3DDC8),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFA83F2D),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Contact details are locked',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Your name and phone number are locked for account security and identity verification. To request a change, contact Aturservicett support and our team will update it after re-verification.',
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: const Color(0xFF5A493B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Locked Full Name Field
                          _buildLockedField(
                            label: 'FULL NAME',
                            value: widget.tradesmanName,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 10),
                          // Locked Phone Field
                          _buildLockedField(
                            label: 'PHONE NUMBER',
                            value: widget.tradesmanPhone,
                            icon: Icons.phone_android_outlined,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Need to update? Email',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF8D7766),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'support@aturservicett.com',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFA83F2D),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Fixed Bottom Actions Row ──────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF8D7766),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF5A493B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Persist inputs back to previous screen
                        Get.back(result: {
                          'pitch': controller.pitch.value,
                          'rate': controller.rate.value,
                          'rateUnit': controller.rateUnit.value,
                          'mainTrade': controller.mainTrade.value,
                          'extraTrades': List<String>.from(controller.extraTrades),
                          'homeArea': controller.homeArea.value,
                          'profileImagePath': controller.profileImagePath.value,
                        });
                        Get.snackbar(
                          'Success',
                          'Your profile changes have been saved!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF22707F),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(15),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA83F2D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save changes',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header Text Helper
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF7A685B),
        letterSpacing: 0.5,
      ),
    );
  }

  // Helper widget for specific Trade Chip / Bagde
  Widget _buildTradeChip({
    required String name,
    required String imagePath,
    required bool isMain,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isMain ? const Color(0xFFA83F2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isMain
            ? null
            : Border.all(
          color: const Color(0xFFF3E5CF),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Use the same asset image as in WhatDoScreen
          Image.asset(
            imagePath,
            width: 18,
            height: 18,
            // Tint white for main chip, native color for extras
            color: isMain ? Colors.white : null,
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isMain ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              size: 13,
              color: isMain ? Colors.white70 : const Color(0xFF8D7766),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for Travel Range Radio list tiles
  Widget _buildTravelRangeTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFA83F2D) : const Color(0xFFEBD7C7),
          width: isSelected ? 1.6 : 1.2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8D7766),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFFA83F2D) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFA83F2D) : const Color(0xFFCDCDCD),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Locked contact details items
  Widget _buildLockedField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF3E5CF),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF8D7766),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8D7766),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.lock_outline,
            color: Color(0xFFEAAE4B),
            size: 20,
          ),
        ],
      ),
    );
  }

  // Dialog showing remaining trades list
  void _showAddTradeDialog(BuildContext context, EditProfileController controller) {
    showDialog(
      context: context,
      builder: (context) {
        final remaining = controller.remainingTrades;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Trade to Add',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
          ),
          content: remaining.isEmpty
              ? Text(
            'No remaining trades available.',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
          )
              : SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: remaining.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFEBD7C7),
              ),
              itemBuilder: (context, index) {
                final trade = remaining[index];
                return ListTile(
                  leading: Image.asset(
                    _getTradeImage(trade),
                    width: 26,
                    height: 26,
                  ),
                  title: Text(
                    trade,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    controller.addTrade(trade);
                    Get.back();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFA83F2D),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
