import 'package:flutter/material.dart';
import '../theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.blueLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: AppColors.pink, size: 44),
              ),
              const SizedBox(height: 24),
              const Text(
                'LacVita',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cada gota importa. Cada conexão transforma.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 15),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    );
                  },
                  child: const Text('Começar'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
