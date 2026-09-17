import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../models.dart';
import '../theme.dart';
import 'coletas_screen.dart';

/// Lista os agendamentos feitos pela doadora durante esta sessão de uso do
/// app. Como os dados são mockados em memória (sem backend), essa lista é
/// reiniciada sempre que o app é recarregado.
class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() => _AgendamentosScreenState();
}

class _AgendamentosScreenState extends State<AgendamentosScreen> {
  // Abre a tela de novo agendamento e, ao voltar (ex.: após confirmar uma
  // coleta), força esta lista a reconstruir e reler o MockData mais
  // recente — sem isso, a lista ficava com os dados antigos até o usuário
  // sair e voltar para a aba de novo.
  Future<void> _novoAgendamento() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ColetasScreen()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appointments = [...MockData.instance.appointments]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Novo agendamento',
            onPressed: _novoAgendamento,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: appointments.isEmpty
            ? _EmptyState(onAgendar: _novoAgendamento)
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Text('${appointments.length} agendamento(s) registrado(s)',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  ...List.generate(
                    appointments.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AppointmentCard(
                        // O mais recente confirmado (primeiro após ordenar
                        // por data de criação) é sempre a "próxima coleta".
                        appointment: appointments[i],
                        isNext: i == 0,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAgendar;
  const _EmptyState({required this.onAgendar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
            child: const Icon(Icons.event_busy_rounded, size: 38, color: AppColors.blue),
          ),
          const SizedBox(height: 20),
          const Text(
            'Você ainda não tem nenhum agendamento',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.navy),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agende sua primeira coleta em casa ou entrega em um ponto parceiro.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAgendar,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agendar coleta'),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isNext;
  const _AppointmentCard({required this.appointment, required this.isNext});

  String _formatDate(DateTime d) {
    const weekdays = [
      'segunda-feira',
      'terça-feira',
      'quarta-feira',
      'quinta-feira',
      'sexta-feira',
      'sábado',
      'domingo',
    ];
    final weekday = weekdays[d.weekday - 1];
    final date = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    final time = '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return '$weekday, $date às $time';
  }

  IconData get _icon =>
      appointment.type.toLowerCase().contains('casa') ? Icons.home_rounded : Icons.storefront_rounded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? AppColors.blueLight : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isNext ? AppColors.blue : AppColors.border, width: isNext ? 1.5 : 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNext ? AppColors.blue : AppColors.blueLight,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 18, color: isNext ? Colors.white : AppColors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNext)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('PRÓXIMA COLETA',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                            letterSpacing: 0.4)),
                  ),
                Text(_formatDate(appointment.dateTime),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 2),
                Text(appointment.type,
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                if (appointment.pointName != null) ...[
                  const SizedBox(height: 2),
                  Text(appointment.pointName!,
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}