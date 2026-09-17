import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import 'historico_screen.dart';
import '../screens/splash_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final donor = MockData.instance.donor;
    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.blueLight,
                  child: Icon(Icons.person_rounded, color: AppColors.blue, size: 34),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(donor.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        const Text('Doadora ativa', style: TextStyle(color: AppColors.textGrey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            _ProfileTile(icon: Icons.badge_rounded, label: 'Meus dados', onTap: () {}),
            _ProfileTile(
              icon: Icons.receipt_long_rounded,
              label: 'Histórico de doações',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoricoScreen()),
                );
              },
            ),
            _ProfileTile(icon: Icons.location_on_rounded, label: 'Endereços salvos', onTap: () {}),
            _ProfileTile(icon: Icons.settings_rounded, label: 'Configurações', onTap: () {}),
            _ProfileTile(icon: Icons.help_rounded, label: 'Ajuda e suporte', onTap: () {}),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _ProfileTile(
              icon: Icons.logout_rounded,
              label: 'Sair',
              color: Colors.redAccent,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileTile({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textDark;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? AppColors.blue),
      title: Text(label, style: TextStyle(color: c, fontWeight: FontWeight.w600)),
      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textGrey.withOpacity(0.6)),
      onTap: onTap,
    );
  }
}
