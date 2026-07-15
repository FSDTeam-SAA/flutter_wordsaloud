import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertiseInquiryScreen extends StatelessWidget {
  const AdvertiseInquiryScreen({super.key});

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _accentColor = Color(0xFFCC4E3C);
  static const _darkText = Color(0xFF1F1F1F);
  static const _mutedText = Color(0xFF7E7267);
  static const _borderColor = Color(0xFFE3C9AD);
  static const _goldColor = Color(0xFFEBAE3D);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvertiseInquiryController());

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: _mutedText,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Back',
                            style: GoogleFonts.outfit(
                              color: _mutedText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'ADVERTISE INQUIRY',
                      style: GoogleFonts.outfit(
                        color: _mutedText,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      color: _darkText,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                    children: const [
                      TextSpan(text: 'Tell us about '),
                      TextSpan(
                        text: 'your',
                        style: TextStyle(
                          color: _accentColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(text: '\nbusiness.'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll be in touch when ad slots open.',
                  style: GoogleFonts.outfit(
                    color: _darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E3C9),
                    borderRadius: BorderRadius.circular(8),
                    border: const Border(
                      left: BorderSide(color: _goldColor, width: 3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Early inquiries get first pick',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF8A631E),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Ad slots launch 3-6 months after launch.',
                        style: GoogleFonts.outfit(
                          color: _darkText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _FieldLabel('BUSINESS NAME'),
                const SizedBox(height: 8),
                _InquiryField(
                  controller: controller.businessNameController,
                  hintText: 'e.g. Bhagwansingh\'s Hardware',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                _FieldLabel('PHONE (WHATSAPP)'),
                const SizedBox(height: 8),
                _InquiryField(
                  controller: controller.phoneController,
                  hintText: '+1 868 XXX-XXXX',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                _FieldLabel('TRADES YOU\'D ADVERTISE TO'),
                const SizedBox(height: 8),
                _InquiryField(
                  controller: controller.tradesController,
                  hintText: 'e.g. Plumbers, electricians...',
                  minLines: 2,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => controller.sendInquiry(),
                ),
                const SizedBox(height: 30),
                CustomButton(text: 'Send inquiry', height: 50, borderRadius: 16,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdvertiseInquiryController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final tradesController = TextEditingController();

  void sendInquiry() {
    if (!formKey.currentState!.validate()) return;

    Get.snackbar(
      'Inquiry sent',
      'We will be in touch when ad slots open.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AdvertiseInquiryScreen._darkText,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    businessNameController.dispose();
    phoneController.dispose();
    tradesController.dispose();
    super.onClose();
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: AdvertiseInquiryScreen._mutedText,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _InquiryField extends StatelessWidget {
  const _InquiryField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      minLines: minLines,
      maxLines: maxLines,
      style: GoogleFonts.outfit(
        color: AdvertiseInquiryScreen._darkText,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          color: const Color(0xFF9D948B),
          fontSize: 13,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        enabledBorder: _border(),
        focusedBorder: _border(AdvertiseInquiryScreen._goldColor, 1.3),
        errorBorder: _border(AdvertiseInquiryScreen._accentColor, 1.2),
        focusedErrorBorder: _border(AdvertiseInquiryScreen._accentColor, 1.3),
      ),
    );
  }

  OutlineInputBorder _border([
    Color color = AdvertiseInquiryScreen._borderColor,
    double width = 1,
  ]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
