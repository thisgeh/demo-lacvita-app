import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const LacVitaApp());
}

class LacVitaApp extends StatelessWidget {
  const LacVitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LacVita',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}
