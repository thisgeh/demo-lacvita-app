import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

/// Gráfico de barras simples (sem dependências externas) para mostrar a
/// evolução das doações (semana, mês ou ano).
class EvolutionBarChart extends StatelessWidget {
  final List<MonthlyPoint> points;
  final double height;

  const EvolutionBarChart({super.key, required this.points, this.height = 160});

  // Espaço reservado para o texto do valor (em cima) + espaçamentos +
  // texto do label (embaixo), para a barra nunca ultrapassar a altura
  // total disponível (o que causava overflow no rodapé do gráfico).
  static const double _reservedHeight = 42;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.map((e) => e.liters).reduce((a, b) => a > b ? a : b);
    final maxBarHeight = height - _reservedHeight;
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: points.map((p) {
          final isLast = p == points.last;
          final ratio = maxValue == 0 ? 0.0 : (p.liters / maxValue);
          final barHeight = (ratio * maxBarHeight).clamp(6.0, maxBarHeight).toDouble();
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.liters.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 10,
                      color: isLast ? AppColors.blue : AppColors.textGrey,
                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isLast ? AppColors.blue : AppColors.blueSoft,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
