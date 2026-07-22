import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/client_profile/controller/client_profile_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({
    super.key,
    this.initialName = 'Keisha P.',
    this.initialPhone = '+1 (868) 754-2288',
    this.initialArea = 'Chaguanas',
    this.initialImagePath,
  });

  final String initialName;
  final String initialPhone;
  final String initialArea;
  final String? initialImagePath;

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _headerColor = Color(0xFFBC4437);
  static const _darkText = Color(0xFF221C18);
  static const _mutedText = Color(0xFF84796F);
  static const _borderColor = Color(0xFFD3C7BD);
  static const _goldColor = Color(0xFFF6C451);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ClientEditProfileController(
        initialName: initialName,
        initialPhone: initialPhone,
        initialArea: initialArea,
        initialImagePath: initialImagePath,
      ),
      tag: hashCode.toString(),
    );

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: _headerColor,
            padding: const EdgeInsets.only(
              top: 60,
              left: 18,
              right: 18,
              bottom: 22,
            ),
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
                    Obx(
                      () => _HeaderPillButton(
                        label: controller.isSaving.value ? 'Saving' : 'Save',
                        onTap: controller.isSaving.value
                            ? () {}
                            : controller.saveProfile,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: controller.pickProfileImage,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFDA78),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Obx(
                            () => _ProfileImage(
                              imagePath: controller.profileImagePath.value,
                              initial: controller.initialLetter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: _headerColor, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: _headerColor,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Edit Profile',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Update your account details',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 22, 14, 28),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel('ACCOUNT INFO'),
                    const SizedBox(height: 10),
                    _EditProfileField(
                      controller: controller.nameController,
                      label: 'NAME',
                      hintText: 'Enter your name',
                      icon: Icons.person,
                      iconColor: const Color(0xFF6D95AC),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _EditProfileField(
                      controller: controller.phoneController,
                      label: 'PHONE',
                      hintText: 'Enter your phone number',
                      icon: Icons.phone_iphone,
                      iconColor: const Color(0xFF1F272C),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _EditProfileField(
                      controller: controller.areaController,
                      label: 'AREA',
                      hintText: 'Enter your area',
                      icon: Icons.location_on,
                      iconColor: const Color(0xFFE05249),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => controller.saveProfile(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isSaving.value
                              ? null
                              : controller.saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _headerColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: controller.isSaving.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Save changes',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClientEditProfileController extends GetxController {
  ClientEditProfileController({
    required String initialName,
    required String initialPhone,
    required String initialArea,
    String? initialImagePath,
  }) : profileImagePath = RxnString(initialImagePath) {
    nameController = TextEditingController(text: initialName);
    phoneController = TextEditingController(text: initialPhone);
    areaController = TextEditingController(text: initialArea);
  }

  final formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final RxnString profileImagePath;
  final isSaving = false.obs;
  late final ClientProfileController _profileController =
      Get.find<ClientProfileController>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController areaController;

  Future<void> pickProfileImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (image == null) return;

    profileImagePath.value = image.path;
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    final success = await _profileController.updateClientProfile(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      area: areaController.text.trim(),
      profileImagePath: profileImagePath.value,
    );
    isSaving.value = false;

    if (!success) {
      final message = _profileController.errorMessage.value.trim();
      Get.snackbar(
        'Profile not updated',
        message.isNotEmpty ? message : 'Please try again.',
      );
      return;
    }

    Get.back<Map<String, String?>>(
      result: {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'area': areaController.text.trim(),
        'profileImagePath': profileImagePath.value,
      },
    );
  }

  String get initialLetter {
    final name = nameController.text.trim();
    if (name.isEmpty) return 'U';
    return name.substring(0, 1).toUpperCase();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    areaController.dispose();
    super.onClose();
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.imagePath, required this.initial});

  final String? imagePath;
  final String initial;

  @override
  Widget build(BuildContext context) {
    final selectedImagePath = imagePath;

    if (selectedImagePath != null && selectedImagePath.isNotEmpty) {
      return Image.file(File(selectedImagePath), fit: BoxFit.cover);
    }

    return Container(
      alignment: Alignment.center,
      color: EditProfileScreen._goldColor,
      child: Text(
        initial,
        style: GoogleFonts.outfit(
          color: EditProfileScreen._darkText,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
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
        color: EditProfileScreen._mutedText,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _EditProfileField extends StatelessWidget {
  const _EditProfileField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.iconColor,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final Color iconColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: GoogleFonts.outfit(
        color: EditProfileScreen._darkText,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        hintText: hintText,
        labelStyle: GoogleFonts.outfit(
          color: EditProfileScreen._mutedText,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
        hintStyle: GoogleFonts.outfit(
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: _border(),
        focusedBorder: _border(EditProfileScreen._headerColor, 1.4),
        errorBorder: _border(EditProfileScreen._headerColor, 1.2),
        focusedErrorBorder: _border(EditProfileScreen._headerColor, 1.4),
      ),
    );
  }

  OutlineInputBorder _border([
    Color color = EditProfileScreen._borderColor,
    double width = 1,
  ]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
