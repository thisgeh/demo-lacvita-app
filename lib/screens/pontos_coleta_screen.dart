import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../models.dart';
import '../services/matching_service.dart';
import '../theme.dart';

class PontosColetaScreen extends StatefulWidget {
  const PontosColetaScreen({super.key});

  @override
  State<PontosColetaScreen> createState() => _PontosColetaScreenState();
}

class _PontosColetaScreenState extends State<PontosColetaScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final matches = MatchingService.rank(
      MockData.instance.donor,
      MockData.instance.collectionPoints,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Pontos de coleta')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  hintText: 'Buscar endereço...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            // Ilustração simples de "mapa" para representar o mockup
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blueSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.map_rounded, size: 46, color: AppColors.blue),
                  ...List.generate(matches.length, (i) {
                    final dx = (i - 1) * 60.0;
                    return Positioned(
                      left: 130 + dx,
                      top: 30 + (i.isEven ? 0 : 40),
                      child: const Icon(Icons.location_on_rounded,
                          color: AppColors.pink, size: 26),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.blue),
                  SizedBox(width: 6),
                  Text(
                    'Ordenado pela IA de acordo com o seu perfil',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: matches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _PointCard(
                  match: matches[i],
                  isTopMatch: i == 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  final PointMatch match;
  final bool isTopMatch;
  const _PointCard({required this.match, required this.isTopMatch});

  @override
  Widget build(BuildContext context) {
    final point = match.point;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTopMatch ? AppColors.blueLight : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isTopMatch ? AppColors.blue : AppColors.border, width: isTopMatch ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTopMatch)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Recomendado para você',
                        style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Text(point.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
              ),
              Text(point.distance,
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(point.tag,
                    style: const TextStyle(fontSize: 11, color: AppColors.blue, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              _CompatibilityTag(percent: match.scorePercent),
            ],
          ),
          const SizedBox(height: 10),
          Text('${point.hours}\n${point.phone}',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12, height: 1.4)),
          if (match.reasons.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: match.reasons
                  .map((r) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(r, style: const TextStyle(fontSize: 10.5, color: AppColors.textDark)),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => _PointDetailScreen(point: point)),
              );
            },
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(42)),
            child: const Text('Ver detalhes'),
          ),
        ],
      ),
    );
  }
}

/// Selo com o percentual de compatibilidade calculado pelo matching
/// inteligente (distância, tipo de coleta preferido, histórico e parceria).
class _CompatibilityTag extends StatelessWidget {
  final int percent;
  const _CompatibilityTag({required this.percent});

  Color get _color {
    if (percent >= 80) return AppColors.success;
    if (percent >= 50) return AppColors.blue;
    return AppColors.textGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$percent% compatível',
          style: TextStyle(fontSize: 11, color: _color, fontWeight: FontWeight.w600)),
    );
  }
}

class _PointDetailScreen extends StatelessWidget {
  final CollectionPoint point;
  const _PointDetailScreen({required this.point});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(point.name, overflow: TextOverflow.ellipsis)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(point.tag,
                  style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.location_on_rounded, text: point.address),
              const SizedBox(height: 10),
              _InfoRow(icon: Icons.schedule_rounded, text: point.hours),
              const SizedBox(height: 10),
              _InfoRow(icon: Icons.call_rounded, text: point.phone),
              const SizedBox(height: 20),
              const Text('Serviços oferecidos',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  if (point.offersHomeCollection) const _ServiceChip('Coleta em casa'),
                  if (point.offersDropOff) const _ServiceChip('Ponto de entrega'),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  MockData.instance.addAppointment(
                    Appointment(
                      dateTime: DateTime.now().add(const Duration(days: 2)),
                      type: 'Entrega em ponto de coleta',
                      pointName: point.name,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coleta agendada com sucesso!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Agendar coleta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: AppColors.textDark))),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final String label;
  const _ServiceChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: AppColors.blueLight,
      side: BorderSide.none,
      labelStyle: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600),
    );
  }
}
