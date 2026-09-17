class CollectionPoint {
  final String name;
  final String tag;
  final String distance;
  final String address;
  final String hours;
  final String phone;
  final bool offersHomeCollection;
  final bool offersDropOff;

  /// Quantas vezes a doadora já usou este ponto (usado no matching
  /// inteligente para priorizar pontos já conhecidos pela doadora).
  final int pastVisits;

  const CollectionPoint({
    required this.name,
    required this.tag,
    required this.distance,
    required this.address,
    required this.hours,
    required this.phone,
    this.offersHomeCollection = true,
    this.offersDropOff = true,
    this.pastVisits = 0,
  });
}

class ChatMessage {
  final String text;
  final bool fromUser;
  final DateTime time;

  ChatMessage({required this.text, required this.fromUser, DateTime? time})
      : time = time ?? DateTime.now();
}

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final String icon; // simple tag used to pick an icon in UI

  const NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
  });
}

class DonationDay {
  final DateTime date;
  final double liters;

  const DonationDay({required this.date, required this.liters});
}

class MonthlyPoint {
  final String label;
  final double liters;

  const MonthlyPoint({required this.label, required this.liters});
}

class ImpactStat {
  final String label;
  final double value; // 0..100
  final String displayValue;

  const ImpactStat({
    required this.label,
    required this.value,
    required this.displayValue,
  });
}

class Donor {
  String name;
  bool isMother;
  bool isBreastfeeding;
  bool alreadyInProgram;
  double totalLiters;
  int babiesFed;
  int donationStreakMonths;

  /// Próxima coleta agendada. `null` significa que a doadora ainda não fez
  /// nenhum agendamento (estado inicial do app).
  DateTime? nextCollection;
  String? nextCollectionType;
  String address;

  Donor({
    required this.name,
    this.isMother = true,
    this.isBreastfeeding = true,
    this.alreadyInProgram = true,
    required this.totalLiters,
    required this.babiesFed,
    required this.donationStreakMonths,
    this.nextCollection,
    this.nextCollectionType,
    required this.address,
  });
}

/// Um agendamento de coleta feito pela doadora (em casa ou entrega em um
/// ponto de coleta). Guardado apenas em memória, então a lista de
/// agendamentos feitos durante os testes da demo é reiniciada sempre que o
/// app é recarregado — não há persistência em disco ou backend.
class Appointment {
  final DateTime dateTime;
  final String type;
  final String? pointName;
  final DateTime createdAt;

  Appointment({
    required this.dateTime,
    required this.type,
    this.pointName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
