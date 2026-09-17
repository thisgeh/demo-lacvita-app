import 'package:flutter/material.dart';
import '../theme.dart';
import 'conecta_blh_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (Icons.app_registration_rounded, 'Você se cadastra e faz a triagem.'),
      (Icons.calendar_month_rounded,
          'Agendamos a coleta ou você leva até um ponto de coleta.'),
      (Icons.favorite_rounded, 'Seu leite chega a quem mais precisa.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Como funciona')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: steps.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, i) {
                    final step = steps[i];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.blueLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(step.$1, color: AppColors.blue),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              step.$2,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textDark,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ConectaBlhScreen()),
                    );
                  },
                  child: const Text('Próximo'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
