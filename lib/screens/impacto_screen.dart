import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/radar_chart.dart';
import '../widgets/evolution_bar_chart.dart';
import 'historico_screen.dart';

/// Índice desta aba dentro do AppShell (Início=0, Coletas=1, Chat=2,
/// Impacto=3, Perfil=4) — usado para saber quando a aba fica visível.
const _kImpactoTabIndex = 3;

class ImpactoScreen extends StatefulWidget {
  const ImpactoScreen({super.key});

  @override
  State<ImpactoScreen> createState() => _ImpactoScreenState();
}

class _ImpactoScreenState extends State<ImpactoScreen> {
  int _periodo = 1; // 0 semana, 1 mês, 2 ano

  // Cada vez que esse contador muda, o radar chart recebe uma nova Key e o
  // Flutter recria seu estado do zero — o que reinicia a animação de
  // entrada do gráfico.
  int _radarPlayCount = 0;
  int? _lastActiveIndex;

  List<MonthlyPoint> get _evolutionData {
    switch (_periodo) {
      case 0:
        return MockData.instance.weeklyEvolution;
      case 2:
        return MockData.instance.yearlyEvolution;
      case 1:
      default:
        return MockData.instance.monthlyEvolution;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final activeIndex = AppShellController.of(context)?.activeIndex;
    final justBecameVisible =
        activeIndex == _kImpactoTabIndex && _lastActiveIndex != _kImpactoTabIndex;
    if (justBecameVisible) {
      setState(() => _radarPlayCount++);
    }
    _lastActiveIndex = activeIndex;
  }

  @override
  Widget build(BuildContext context) {
    final donor = MockData.instance.donor;
    final stats = MockData.instance.impactRadarStats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu impacto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Histórico de doações',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoricoScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            const Text('Visão geral das suas doações',
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatBox(label: 'Litros doados', value: donor.totalLiters.toStringAsFixed(1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(label: 'Bebês alimentados', value: '${donor.babiesFed}'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Radar de impacto',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ImpactRadarChart(key: ValueKey(_radarPlayCount), stats: stats, size: 280),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 6,
                      children: stats
                          .map((s) => Text(
                                '${s.label.replaceAll('\n', ' ')} ${s.displayValue}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Evolução',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _periodo == 0
                  ? 'Litros doados por dia nesta semana'
                  : 'Total acumulado de litros doados até o período',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _PeriodChip(label: 'Semana', selected: _periodo == 0, onTap: () => setState(() => _periodo = 0)),
                const SizedBox(width: 8),
                _PeriodChip(label: 'Mês', selected: _periodo == 1, onTap: () => setState(() => _periodo = 1)),
                const SizedBox(width: 8),
                _PeriodChip(label: 'Ano', selected: _periodo == 2, onTap: () => setState(() => _periodo = 2)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: EvolutionBarChart(
                  key: ValueKey(_periodo),
                  points: _evolutionData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.navy)),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PeriodChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.blue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? AppColors.blue : AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
