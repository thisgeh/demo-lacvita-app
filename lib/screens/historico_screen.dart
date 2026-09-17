import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  DateTime _month = DateTime(2026, 6);

  static const _weekdayLabels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  static const _monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  void _changeMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  @override
  Widget build(BuildContext context) {
    final donationDays = MockData.instance.juneDonationDays
        .where((d) => d.date.year == _month.year && d.date.month == _month.month)
        .toList();
    final donationDates = donationDays.map((d) => d.date.day).toSet();
    final totalLiters = donationDays.fold<double>(0, (sum, d) => sum + d.liters);

    final firstDayOfMonth = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leadingBlanks = firstDayOfMonth.weekday % 7; // Sunday=0 alignment

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Doações')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Acompanhe os dias em que você doou.',
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => _changeMonth(-1),
                ),
                Text('${_monthNames[_month.month - 1]} de ${_month.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: _weekdayLabels
                        .map((l) => Expanded(
                              child: Center(
                                child: Text(l,
                                    style: const TextStyle(
                                        color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leadingBlanks + daysInMonth,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemBuilder: (context, i) {
                      if (i < leadingBlanks) return const SizedBox();
                      final day = i - leadingBlanks + 1;
                      final donated = donationDates.contains(day);
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: donated ? AppColors.blue : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: donated ? Colors.white : AppColors.textDark,
                            fontWeight: donated ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Resumo do mês',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                      label: 'Dias de doação', value: '${donationDays.length}'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                      label: 'Leite doado', value: '${totalLiters.toStringAsFixed(1)} L'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                      label: 'RN alimentados', value: '${(totalLiters / 1.5).ceil()}'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Os dados representados são baseados nas doações registradas no app.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}
