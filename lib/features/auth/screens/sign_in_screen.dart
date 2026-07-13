import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/core/widgets/button_widget.dart';
import 'package:flutter_wordsaloud/features/auth/controller/signin_controller.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_up_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const _backgroundColor = Color(0xFFF5EFE6);
  static const _accentColor = Color(0xFFAE3F30);
  static const _darkTextColor = Color(0xFF1F1F1F);
  static const _mutedTextColor = Color(0xFF6D6D6D);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SigninController());

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Back'),
                      style: _navButtonStyle(_mutedTextColor),
                    ),
                    TextButton(
                      onPressed: () => Get.off(() => const SignUpScreen()),
                      style: _navButtonStyle(_accentColor).copyWith(
                        textStyle: WidgetStatePropertyAll(
                          GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: _darkTextColor,
                      height: 1,
                    ),
                    children: const [
                      TextSpan(text: 'Welcome '),
                      TextSpan(
                        text: 'back.',
                        style: TextStyle(
                          color: _accentColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your email — we\'ll send you a code.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: _darkTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                const _FieldLabel(text: 'EMAIL ADDRESS'),
                const SizedBox(height: 6),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EmailField(
                        hintText: 'keisha@gmail.com',
                        onChanged: (value) {
                          controller.email.value = value;
                          if (controller.emailError.value.isNotEmpty &&
                              value.trim().isNotEmpty) {
                            controller.emailError.value = '';
                          }
                        },
                      ),
                      if (controller.emailError.value.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          controller.emailError.value,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: _accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(text: 'Send code', onPressed: controller.sendCode,height: 50, borderRadius: 16,),
                //_AuthButton(text: 'Send code', onPressed: controller.sendCode),
                const SizedBox(height: 14),
                const _FieldLabel(text: 'VERIFICATION CODE'),
                const SizedBox(height: 8),
                Obx(
                  () => Column(
                    children: [
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        cursorColor: _darkTextColor,
                        keyboardType: TextInputType.number,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textStyle: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _darkTextColor,
                        ),
                        onChanged: (value) {
                          controller.code.value = value;
                          if (controller.codeError.value.isNotEmpty &&
                              value.trim().isNotEmpty) {
                            controller.codeError.value = '';
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 50,
                          fieldWidth: 44,
                          borderWidth: 1.4,
                          activeBorderWidth: 2,
                          selectedBorderWidth: 2,
                          inactiveBorderWidth: 2,
                          errorBorderWidth: 2,
                          activeFillColor: _backgroundColor,
                          inactiveFillColor: _backgroundColor,
                          selectedFillColor: _backgroundColor,
                          activeColor: _accentColor,
                          inactiveColor: _accentColor,
                          selectedColor: _accentColor,
                        ),
                      ),
                      if (controller.codeError.value.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          controller.codeError.value,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: _accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: _mutedTextColor,
                          ),
                          children: const [
                            TextSpan(text: "Didn't get it? "),
                            TextSpan(
                              text: 'Resend',
                              style: TextStyle(
                                color: _accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                CustomButton(text: 'Log in', onPressed: controller.login, height: 50, borderRadius: 16,),
                const SizedBox(height: 18),
                const Divider(color: Color(0xFFE7D9CA), height: 1),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8EF),
                    border: Border.all(color: const Color(0xFFE7C9A2)),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: Color(0xFFB78B48),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: _darkTextColor,
                              height: 1.2,
                            ),
                            children: const [
                              TextSpan(
                                text: 'No password to remember or lose. ',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                              TextSpan(text: 'Just your email.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static ButtonStyle _navButtonStyle(Color color) {
    return TextButton.styleFrom(
      foregroundColor: color,
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 32),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: const Color(0xFF8B7468),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const _EmailField({required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      style: GoogleFonts.outfit(
        fontSize: 14,
        color: SignInScreen._darkTextColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          color: SignInScreen._darkTextColor,
          fontSize: 14,
        ),
        filled: true,
        fillColor: SignInScreen._backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SignInScreen._accentColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SignInScreen._accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: SignInScreen._accentColor,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _AuthButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: SignInScreen._accentColor,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: SignInScreen._accentColor.withValues(alpha: 0.28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
