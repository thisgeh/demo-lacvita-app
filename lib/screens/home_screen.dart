import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import 'agendamentos_screen.dart';
import 'coletas_screen.dart';
import 'notificacoes_screen.dart';
import 'pontos_coleta_screen.dart';
import 'upload_exames_screen.dart';
import 'faq_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _weekday(int w) {
    const days = [
      'segunda-feira',
      'terça-feira',
      'quarta-feira',
      'quinta-feira',
      'sexta-feira',
      'sábado',
      'domingo'
    ];
    return days[w - 1];
  }

  @override
  Widget build(BuildContext context) {
    final donor = MockData.instance.donor;
    final next = donor.nextCollection;
    final hasNext = next != null;
    final dateStr = hasNext
        ? '${_weekday(next.weekday)}, ${next.day.toString().padLeft(2, '0')}/${next.month.toString().padLeft(2, '0')}  ${next.hour}h'
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text('Olá, ${donor.name.split(' ').first}! 👋',
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificacoesScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            const Text('Que bom ter você aqui!',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
            const SizedBox(height: 16),

            // Próxima coleta card — se ela ainda não tem nenhum
            // agendamento, mostra um estado vazio convidando a agendar em
            // vez de uma data fixa (que ficaria no passado com o tempo).
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => hasNext ? const AgendamentosScreen() : const ColetasScreen(),
                  ),
                );
                // Ao voltar dessa tela (ex.: após agendar uma coleta), força
                // a Home a reconstruir e reler os dados mais recentes do
                // MockData — sem isso, a tela ficava com o valor antigo em
                // memória até o usuário trocar de aba manualmente.
                if (context.mounted) {
                  AppShellController.of(context)?.goTo(0);
                }
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_rounded, color: Colors.white70, size: 18),
                        const SizedBox(width: 6),
                        const Text('Próxima coleta',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const Spacer(),
                        Icon(
                          hasNext ? Icons.chevron_right_rounded : Icons.add_circle_outline_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (hasNext) ...[
                      Text(dateStr!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                      const SizedBox(height: 2),
                      Text(donor.nextCollectionType!,
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 6),
                      const Text('Toque para ver seus agendamentos',
                          style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ] else ...[
                      const Text('Você ainda não tem nenhuma coleta agendada',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      const Text('Toque para agendar sua primeira coleta',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.favorite_rounded,
                      label: 'Quero Doar',
                      color: AppColors.pink,
                      onTap: () => AppShellController.of(context)?.goTo(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.location_on_rounded,
                      label: 'Encontrar ponto\nde coleta',
                      color: AppColors.blue,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PontosColetaScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Meu impacto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Litros doados',
                    value: donor.totalLiters.toStringAsFixed(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Bebês alimentados',
                    value: '${donor.babiesFed}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _SectionCard(
              icon: Icons.water_drop_rounded,
              iconColor: AppColors.blue,
              title: 'Dica diária para você',
              child: const Text(
                'Hidrate-se bastante e mantenha uma alimentação equilibrada.',
                style: TextStyle(color: AppColors.textDark, height: 1.4),
              ),
            ),
            const SizedBox(height: 14),

            _SectionCard(
              icon: Icons.health_and_safety_rounded,
              iconColor: AppColors.success,
              title: 'Central da saúde',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HIV, Hepatites B e C (HBsAg e Anti-HCV)',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('Você tem testes pendentes:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const UploadExamesScreen()),
                      );
                    },
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text('Fazer upload aqui'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            _SectionCard(
              icon: Icons.help_outline_rounded,
              iconColor: AppColors.navy,
              title: 'FAQ',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FaqScreen()),
                );
              },
              child: const Text(
                'Tire suas dúvidas sobre doação de leite humano',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.navy)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  final VoidCallback? onTap;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                if (onTap != null) ...[
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
                ],
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}