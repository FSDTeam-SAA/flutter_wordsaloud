import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFadeAnimation;
  
  final String _titlePart1 = "Aturservice";
  final String _titlePart2 = "tt";
  String _displayedTitle1 = "";
  String _displayedTitle2 = "";
  bool _showSubtext = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // 1. Fade in the logo
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    // 2. Type out "Aturservice"
    for (int i = 1; i <= _titlePart1.length; i++) {
      if (!mounted) return;
      setState(() {
        _displayedTitle1 = _titlePart1.substring(0, i);
      });
      await Future.delayed(const Duration(milliseconds: 80));
    }

    // 3. Type out "tt"
    for (int i = 1; i <= _titlePart2.length; i++) {
      if (!mounted) return;
      setState(() {
        _displayedTitle2 = _titlePart2.substring(0, i);
      });
      await Future.delayed(const Duration(milliseconds: 120));
    }

    // 4. Fade in the subtext
    if (!mounted) return;
    setState(() {
      _showSubtext = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA83E2D), // Primary Brand Color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            FadeTransition(
              opacity: _logoFadeAnimation,
              child: Image.asset(
                'assets/images/aturservicett-logo-full-512px 2.png',
                width: 140,
                height: 140,
              ),
            ),
            const SizedBox(height: 48),
            
            // Sequential Typewriter Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _displayedTitle1,
                  style: GoogleFonts.outfit(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _displayedTitle2,
                  style: GoogleFonts.outfit(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFAC04A), // Golden Yellow
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle with Fade
            AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _showSubtext ? 1.0 : 0.0,
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
            ),
          ],
        ),
      ),
    );
  }
}
