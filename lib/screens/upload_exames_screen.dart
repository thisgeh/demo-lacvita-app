import 'package:flutter/material.dart';
import '../theme.dart';

class UploadExamesScreen extends StatefulWidget {
  const UploadExamesScreen({super.key});

  @override
  State<UploadExamesScreen> createState() => _UploadExamesScreenState();
}

class _UploadExamesScreenState extends State<UploadExamesScreen> {
  final List<String> _files = [
    'resultado_teste_hiv.pdf',
    'resultado_teste_hepatites_a_e_b.jpg',
  ];

  void _addMockFile() {
    setState(() {
      _files.add('novo_exame_${_files.length + 1}.pdf');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Arquivo adicionado (simulado).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Central da saúde')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Faça upload aqui!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navy)),
              const SizedBox(height: 4),
              const Text('Permitido pdf, jpg e png', style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 16),
              InkWell(
                onTap: _addMockFile,
                borderRadius: BorderRadius.circular(16),
                child: DottedBox(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    alignment: Alignment.center,
                    child: Column(
                      children: const [
                        Icon(Icons.cloud_upload_rounded, color: AppColors.blue, size: 36),
                        SizedBox(height: 10),
                        Text('Arraste e solte seu(s) arquivo(s) aqui ou',
                            style: TextStyle(color: AppColors.textGrey)),
                        Text('procure em seu dispositivo',
                            style: TextStyle(
                                color: AppColors.blue, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ..._files.map((f) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file_rounded, color: AppColors.blue),
                        const SizedBox(width: 10),
                        Expanded(child: Text(f, overflow: TextOverflow.ellipsis)),
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                      ],
                    ),
                  )),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exames enviados com sucesso!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Enviar exames'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Caixa com borda tracejada simples (implementada via CustomPaint,
/// sem depender de pacotes externos).
class DottedBox extends StatelessWidget {
  final Widget child;
  const DottedBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.5)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}
