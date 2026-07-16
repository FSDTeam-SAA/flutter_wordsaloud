import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_wordsaloud/core/di/service_locator.dart';
import 'package:flutter_wordsaloud/features/splash/screens/splash_screen.dart';

import 'core/init/app_initializer.dart';

void main() async{
  await AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aturservice tt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA83E2D)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
