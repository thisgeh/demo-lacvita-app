import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../models.dart';
import '../theme.dart';

class NotificacoesScreen extends StatelessWidget {
  const NotificacoesScreen({super.key});

  IconData _iconFor(String tag) {
    switch (tag) {
      case 'reminder':
        return Icons.alarm_rounded;
      case 'tip':
        return Icons.water_drop_rounded;
      case 'success':
        return Icons.celebration_rounded;
      case 'new':
        return Icons.fiber_new_rounded;
      case 'accessibility':
        return Icons.accessibility_new_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorFor(String tag) {
    switch (tag) {
      case 'reminder':
        return AppColors.blue;
      case 'tip':
        return AppColors.blue;
      case 'success':
        return AppColors.success;
      case 'new':
        return AppColors.pink;
      case 'accessibility':
        return AppColors.navy;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = MockData.instance.notifications;
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final NotificationItem n = items[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _colorFor(n.icon).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_iconFor(n.icon), color: _colorFor(n.icon), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(n.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                            ),
                            Text(n.time, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(n.description, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
