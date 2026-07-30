import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';
import 'package:flutter_wordsaloud/features/auth/controller/auth_controller.dart';
import 'package:flutter_wordsaloud/features/auth/controller/signup_controller.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    final controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Get.off(() => const SignInScreen()),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6D6D6D),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => SignInScreen()),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFA83F2D),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      child: const Text('Log in'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Header
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
                        text: "set up.",
                        style: TextStyle(color: Color(0xFFA83F2D)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your email — we\'ll send a code to verify.',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Color(0xFF1E1E1E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),

                // Email
                const LabelText(text: 'Email Address'),
                const SizedBox(height: 8),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        hintText: 'jeanne@gmail.com',
                        onChanged: (v) {
                          controller.email.value = v;
                          if (controller.emailError.value.isNotEmpty &&
                              v.trim().isNotEmpty) {
                            controller.emailError.value = '';
                          }
                        },
                      ),
                      if (controller.emailError.value.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          controller.emailError.value,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: const Color(0xFFA83F2D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (controller.apiError.value.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          controller.apiError.value,
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
                const SizedBox(height: 20),

                // SMS Code
                Obx(
                  () => Opacity(
                    opacity: controller.isSmsCodeVisible.value ? 1.0 : 0.4,
                    child: IgnorePointer(
                      ignoring: !controller.isSmsCodeVisible.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LabelText(text: 'Verification code'),
                          const SizedBox(height: 8),
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PinCodeTextField(
                                  cursorColor: Colors.black,
                                  appContext: context,
                                  length: 6,
                                  onChanged: (v) {
                                    controller.smsCode.value = v;
                                    if (controller
                                            .smsCodeError
                                            .value
                                            .isNotEmpty &&
                                        v.trim().isNotEmpty) {
                                      controller.smsCodeError.value = '';
                                    }
                                  },
                                  pinTheme: PinTheme(
                                    borderWidth: 1,
                                    activeBorderWidth: 1,
                                    selectedBorderWidth: 1,
                                    inactiveBorderWidth: 1,
                                    errorBorderWidth: 1,
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(8),
                                    fieldHeight: 50,
                                    fieldWidth: 44,
                                    activeFillColor: Colors.white,
                                    inactiveFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    activeColor: const Color(0xFFA83F2D),
                                    inactiveColor: Color(0xFF6D6D6D),
                                    selectedColor: const Color(0xFFA83F2D),
                                  ),
                                ),
                                if (controller
                                    .smsCodeError
                                    .value
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    controller.smsCodeError.value,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't get it? ",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: const Color(0xFF6D6D6D),
                                ),
                              ),
                              TextButton(
                                onPressed: controller.isResendingCode.value
                                    ? null
                                    : controller.resendVerificationCode,
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFC34D3C),
                                  disabledForegroundColor: const Color(
                                    0xFFC34D3C,
                                  ).withValues(alpha: 0.45),
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  textStyle: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                child: Text(
                                  controller.isResendingCode.value
                                      ? 'Sending...'
                                      : 'Resend',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Just a few details
                const Center(child: LabelText(text: 'Just a few details')),
                const SizedBox(height: 12),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  hintText: 'Adam',
                                  onChanged: (v) {
                                    controller.firstName.value = v;
                                    if (controller
                                            .firstNameError
                                            .value
                                            .isNotEmpty &&
                                        v.trim().isNotEmpty) {
                                      controller.firstNameError.value = '';
                                    }
                                  },
                                ),
                                if (controller
                                    .firstNameError
                                    .value
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    controller.firstNameError.value,
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  hintText: 'Leivine',
                                  onChanged: (v) {
                                    controller.lastName.value = v;
                                    if (controller
                                            .lastNameError
                                            .value
                                            .isNotEmpty &&
                                        v.trim().isNotEmpty) {
                                      controller.lastNameError.value = '';
                                    }
                                  },
                                ),
                                if (controller
                                    .lastNameError
                                    .value
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    controller.lastNameError.value,
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
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Only your first and last name initial will appear publicly.',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Color(0xFF6D6D6D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const LabelText(text: 'Your Area'),
                    Text(
                      'Optional',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'e.g. Chaguanas',
                  onChanged: (v) => controller.area.value = v,
                ),
                const SizedBox(height: 40),

                // Button
                Obx(
                  () => controller.isLoading.value
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: CircularProgressIndicator(
                              color: Color(0xFFA83F2D),
                            ),
                          ),
                        )
                      : CustomButton(
                          text: controller.isSmsCodeVisible.value
                              ? 'Complete sign up'
                              : 'Send verification code',
                          onPressed: controller.onMainButtonPressed,
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextInputType? textInputType;
  final Function(String) onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(color: Color(0xFF6D6D6D)),
        filled: true,
        fillColor: Color(0xFFF5EFE6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFC34D3C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFC34D3C)),
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  const LabelText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F1F1F),
      ),
    );
  }
}
