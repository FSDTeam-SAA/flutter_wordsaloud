import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/features/splash/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: const Color(0xFFA83E2D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Logo
            FadeTransition(
              opacity: controller.logoFadeAnimation,
              child: Image.asset(
                'assets/images/aturservicett-logo-full-512px 2.png',
                width: 140,
                height: 140,
              ),
            ),
            const SizedBox(height: 48),
            
            // LogoText Image with Reveal Animation
            AnimatedBuilder(
              animation: controller.textRevealAnimation,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: controller.textRevealAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/logotext.png',
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle with Reactive Visibility
            Obx(() => AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: controller.showSubtext.value ? 1.0 : 0.0,
              child: Text(
                "Skilled professional at your service in TnT",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
