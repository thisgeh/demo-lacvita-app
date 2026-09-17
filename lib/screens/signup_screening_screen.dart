import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';

class SignupScreeningScreen extends StatefulWidget {
  const SignupScreeningScreen({super.key});

  @override
  State<SignupScreeningScreen> createState() => _SignupScreeningScreenState();
}

class _SignupScreeningScreenState extends State<SignupScreeningScreen> {
  bool? isMother;
  bool? isBreastfeeding;

  bool get _canContinue => isMother != null && isBreastfeeding != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Para começar, precisamos saber',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy),
              ),
              const SizedBox(height: 24),
              _YesNoQuestion(
                question: 'Você é mãe?',
                value: isMother,
                onChanged: (v) => setState(() => isMother = v),
              ),
              const SizedBox(height: 20),
              _YesNoQuestion(
                question: 'Está amamentando?',
                value: isBreastfeeding,
                onChanged: (v) => setState(() => isBreastfeeding = v),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue
                      ? () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const AppShell()),
                            (route) => false,
                          );
                        }
                      : null,
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

class _YesNoQuestion extends StatelessWidget {
  final String question;
  final bool? value;
  final ValueChanged<bool> onChanged;

  const _YesNoQuestion({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ChoiceButton(
                label: 'Sim',
                selected: value == true,
                onTap: () => onChanged(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ChoiceButton(
                label: 'Não',
                selected: value == false,
                onTap: () => onChanged(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.blue : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
