import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../models.dart';
import '../theme.dart';
import 'pontos_coleta_screen.dart';

class ColetasScreen extends StatefulWidget {
  const ColetasScreen({super.key});

  @override
  State<ColetasScreen> createState() => _ColetasScreenState();
}

class _ColetasScreenState extends State<ColetasScreen> {
  int _tipo = 0; // 0 = coleta em casa, 1 = levar a um ponto

  // Data/hora padrão: amanhã às 14h — sempre no futuro em relação a hoje,
  // qualquer que seja o dia em que o app for aberto.
  late DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 14, minute: 0);

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate() async {
    final today = _today;
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(today) ? today : _date,
      firstDate: today,
      lastDate: DateTime(today.year + 2, 12, 31),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _confirmar() {
    final selected = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    if (selected.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha uma data e hora futuras para agendar.')),
      );
      return;
    }

    final tipoLabel = _tipo == 0 ? 'coleta em casa' : 'entrega em ponto de coleta';
    final d = '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}';
    final h = '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tudo certo!'),
        content: Text(
          'Sua $tipoLabel foi agendada para $d às $h.\n\nVocê receberá um lembrete antes da coleta.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                MockData.instance.addAppointment(
                  Appointment(
                    dateTime: selected,
                    type: _tipo == 0 ? 'Coleta em casa' : 'Entrega em ponto de coleta',
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Ok, entendi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamento')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            const Text('Escolha a melhor opção para você',
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 16),
            const Text('Tipo de coleta',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 10),
            _TipoCard(
              icon: Icons.home_rounded,
              title: 'Coleta em casa',
              subtitle: 'Um colaborador irá até você',
              selected: _tipo == 0,
              onTap: () => setState(() => _tipo = 0),
            ),
            const SizedBox(height: 10),
            _TipoCard(
              icon: Icons.storefront_rounded,
              title: 'Levar a um ponto',
              subtitle: 'Você leva até um ponto próximo',
              selected: _tipo == 1,
              onTap: () => setState(() => _tipo = 1),
            ),
            if (_tipo == 1) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PontosColetaScreen()),
                  );
                },
                icon: const Icon(Icons.map_rounded, size: 18),
                label: const Text('Ver pontos de coleta no mapa'),
              ),
            ],
            const SizedBox(height: 22),
            const Text('Data', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 8),
            _PickerField(
              icon: Icons.calendar_today_rounded,
              label:
                  '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}',
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            const Text('Hora', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 8),
            _PickerField(
              icon: Icons.access_time_rounded,
              label: _time.format(context),
              onTap: _pickTime,
            ),
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: _confirmar,
              child: const Text('Confirmar agendamento'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _TipoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.blueLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.blue : AppColors.border, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.blue : AppColors.textGrey),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: selected ? true : false,
              onChanged: (_) => onTap(),
              activeColor: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerField({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textGrey),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
