import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_screen.dart';
import 'signup_screening_screen.dart';

class ConectaBlhScreen extends StatefulWidget {
  const ConectaBlhScreen({super.key});

  @override
  State<ConectaBlhScreen> createState() => _ConectaBlhScreenState();
}

class _ConectaBlhScreenState extends State<ConectaBlhScreen> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Antes de tudo')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Você já faz parte do programa Conecta BLH?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 24),
              _OptionCard(
                title: 'Sim, já faço parte do Conecta BLH',
                subtitle: 'Já sou doadora ou tenho cadastro.',
                selected: _selected == 0,
                onTap: () => setState(() => _selected = 0),
              ),
              const SizedBox(height: 14),
              _OptionCard(
                title: 'Não, sou nova aqui',
                subtitle: 'Tenho interesse em doar e quero saber mais.',
                selected: _selected == 1,
                onTap: () => setState(() => _selected = 1),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                          if (_selected == 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const SignupScreeningScreen()),
                            );
                          }
                        },
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.blueLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.blue : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
