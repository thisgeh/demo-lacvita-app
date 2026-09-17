import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

/// Radar chart simples desenhado manualmente (sem dependências externas),
/// inspirado na tela "Meu impacto" do protótipo.
///
/// O polígono de dados "cresce" do centro até os valores reais assim que o
/// widget aparece na tela, em vez de já surgir desenhado — dá vida ao
/// gráfico mesmo usando dados mockados.
class ImpactRadarChart extends StatefulWidget {
  final List<ImpactStat> stats;
  final double size;

  const ImpactRadarChart({super.key, required this.stats, this.size = 280});

  @override
  State<ImpactRadarChart> createState() => _ImpactRadarChartState();
}

class _ImpactRadarChartState extends State<ImpactRadarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            painter: _RadarPainter(stats: widget.stats, progress: _progress.value),
            child: Container(),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<ImpactStat> stats;
  final double progress;
  _RadarPainter({required this.stats, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 36;
    final n = stats.length;
    final angleStep = (2 * math.pi) / n;
    const startAngle = -math.pi / 2;

    final gridPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // grid rings
    for (int ring = 1; ring <= 4; ring++) {
      final r = radius * ring / 4;
      final path = Path();
      for (int i = 0; i <= n; i++) {
        final angle = startAngle + angleStep * (i % n);
        final p = Offset(
          center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle),
        );
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // axes + labels (fade in junto com a animação, sem se mover)
    final labelStyle = TextStyle(
      color: AppColors.textDark.withOpacity(progress),
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );
    for (int i = 0; i < n; i++) {
      final angle = startAngle + angleStep * i;
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, end, gridPaint);

      final labelOffset = Offset(
        center.dx + (radius + 24) * math.cos(angle),
        center.dy + (radius + 24) * math.sin(angle),
      );
      final tp = TextPainter(
        text: TextSpan(text: stats[i].label, style: labelStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 74);
      tp.paint(
        canvas,
        Offset(labelOffset.dx - tp.width / 2, labelOffset.dy - tp.height / 2),
      );
    }

    // data polygon — cresce do centro (progress 0) até o valor real
    // (progress 1), dando o efeito de animação de entrada.
    final dataPath = Path();
    final points = <Offset>[];
    for (int i = 0; i < n; i++) {
      final angle = startAngle + angleStep * i;
      final value = (stats[i].value.clamp(0, 100)) / 100 * progress;
      final p = Offset(
        center.dx + radius * value * math.cos(angle),
        center.dy + radius * value * math.sin(angle),
      );
      points.add(p);
      if (i == 0) {
        dataPath.moveTo(p.dx, p.dy);
      } else {
        dataPath.lineTo(p.dx, p.dy);
      }
    }
    dataPath.close();

    final fillPaint = Paint()
      ..color = AppColors.blue.withOpacity(0.28 * progress)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = AppColors.blue.withOpacity(math.max(progress, 0.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);

    final dotPaint = Paint()..color = AppColors.blue.withOpacity(progress);
    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(
        p,
        4,
        Paint()
          ..color = Colors.white.withOpacity(progress)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.stats != stats;
}
