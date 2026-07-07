import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';
import 'package:flutter_wordsaloud/features/auth/controller/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                'Quick verification + a few details',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Color(0xFF1E1E1E),
                  fontWeight: FontWeight.w400
                ),
              ),
              const SizedBox(height: 32),

              // Phone Number
              const LabelText(text: 'Phone Number'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBD7C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+186',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6D6D6D)
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hintText: '543-2365',
                      onChanged: (v) => controller.phoneNumber.value = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Email
              const LabelText(text: 'Your Email'),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'jeanne@gmail.com',
                onChanged: (v) => controller.email.value = v,
              ),
              const SizedBox(height: 20),

              // SMS Code
              Obx(() => Opacity(
                    opacity: controller.isSmsCodeVisible.value ? 1.0 : 0.4,
                    child: IgnorePointer(
                      ignoring: !controller.isSmsCodeVisible.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LabelText(text: 'Sms Code'),
                          const SizedBox(height: 8),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            onChanged: (v) => controller.smsCode.value = v,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12),
                              fieldHeight: 50,
                              fieldWidth: 45,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              activeColor: const Color(0xFFA83F2D),
                              inactiveColor: Colors.grey.shade400,
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                children: const [
                                  TextSpan(text: "Don't get it? "),
                                  TextSpan(
                                    text: 'Resend',
                                    style: TextStyle(
                                      color: Color(0xFFA83F2D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 24),

              // Just a few details
              const Center(
                child: LabelText(text: 'Just a few details'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'Adam',
                      onChanged: (v) => controller.firstName.value = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hintText: 'Leivine',
                      onChanged: (v) => controller.lastName.value = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Only your first and last name initial will appear publicly.',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.black45,
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
                    style: GoogleFonts.outfit(fontSize: 14, color: Colors.black38),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'e.g. Berlin',
                onChanged: (v) => controller.area.value = v,
              ),
              const SizedBox(height: 40),

              // Button
              Obx(() => CustomButton(
                    text: controller.isSmsCodeVisible.value
                        ? 'Complete sign up'
                        : 'Send verification code',
                    onPressed: controller.onMainButtonPressed,
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(color: Colors.black26),
        filled: true,
        fillColor: Color(0xFFF5EFE6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC34D3C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
    );
  }
}
