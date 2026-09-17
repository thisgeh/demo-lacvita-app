import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import 'signup_screening_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'juliana.silva@email.com');
  final _passCtrl = TextEditingController(text: '••••••••');
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text('Que bom te ver de novo! 💙',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy)),
              const SizedBox(height: 4),
              const Text('Faça login para continuar',
                  style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 28),
              const Text('E-mail ou CPF',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(hintText: 'Digite seu e-mail ou CPF'),
              ),
              const SizedBox(height: 16),
              const Text('Senha', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Digite sua senha'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Esqueci minha senha'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.4),
                        )
                      : const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('ou', style: TextStyle(color: AppColors.textGrey)),
                ),
                Expanded(child: Divider()),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _login,
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                  label: const Text('Entrar com Google'),
                ),
              ),
              const Spacer(),
              Center(
                child: Wrap(
                  children: [
                    const Text('Ainda não tem conta? ',
                        style: TextStyle(color: AppColors.textGrey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const SignupScreeningScreen()),
                        );
                      },
                      child: const Text('Criar conta',
                          style: TextStyle(
                              color: AppColors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
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
