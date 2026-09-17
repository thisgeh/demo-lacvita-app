import 'models.dart';

/// Fonte única de dados mockados, simulando um pequeno "backend" em memória
/// para que o app seja funcional de ponta a ponta sem precisar de servidor.
class MockData {
  MockData._();
  static final MockData instance = MockData._();

  final Donor donor = Donor(
    name: 'Juliana Silva',
    totalLiters: 12.1,
    babiesFed: 8,
    donationStreakMonths: 5,
    address: 'R. Lins de Vasconcelos, 110 - Vila Mariana, São Paulo - SP',
  );

  /// Agendamentos feitos pela doadora durante a sessão de uso do app
  /// (mockado, guardado só em memória — some ao recarregar o app). Começa
  /// vazia: a doadora ainda não tem nenhum agendamento até confirmar o
  /// primeiro na tela de Coletas.
  final List<Appointment> appointments = [];

  /// Registra um novo agendamento e atualiza a "Próxima coleta" exibida na
  /// Home para refletir o compromisso mais recente.
  void addAppointment(Appointment appointment) {
    appointments.add(appointment);
    donor.nextCollection = appointment.dateTime;
    donor.nextCollectionType = appointment.type;
  }

  final List<CollectionPoint> collectionPoints = const [
    CollectionPoint(
      name: 'Banco de Leite Humano - Vila Mariana',
      tag: 'Parceiro oficial',
      distance: '500m',
      address: 'Av. Lins de Vasconcelos, 1234 - Vila Mariana, São Paulo - SP',
      hours: 'Seg a Sex: 8h às 17h | Sáb: 8h às 12h',
      phone: '(11) 1234-5678',
      pastVisits: 2,
    ),
    CollectionPoint(
      name: 'Hospital Municipal do Ipiranga',
      tag: 'Parceiro oficial',
      distance: '1.8km',
      address: 'R. Bom Pastor, 400 - Ipiranga, São Paulo - SP',
      hours: 'Seg a Sáb: 7h às 19h',
      phone: '(11) 2345-6789',
    ),
    CollectionPoint(
      name: 'UBS Jardim Aeroporto',
      tag: 'Ponto de apoio',
      distance: '3.2km',
      address: 'R. das Rosas, 88 - Jardim Aeroporto, São Paulo - SP',
      hours: 'Seg a Sex: 8h às 16h',
      phone: '(11) 3456-7890',
      offersHomeCollection: false,
    ),
  ];

  final List<FaqItem> faq = const [
    FaqItem(
      question: 'Como armazenar o leite corretamente?',
      answer:
          'Guarde o leite ordenhado em vidro esterilizado, com tampa plástica, '
          'identificado com data e hora da coleta. Mantenha na geladeira, '
          'de preferência na parte mais fria, longe da porta.',
    ),
    FaqItem(
      question: 'Quanto tempo posso deixar o leite armazenado na geladeira?',
      answer:
          'O leite humano ordenhado pode ficar na geladeira por até 12 horas. '
          'Se não for consumido dentro desse período, ele pode ser congelado '
          'por até 15 dias.',
    ),
    FaqItem(
      question: 'Como funciona a entrega do leite para doação?',
      answer:
          'Você pode agendar uma coleta em casa, em que um colaborador vai até '
          'você, ou levar o leite pessoalmente a um ponto de coleta parceiro '
          'próximo do seu endereço.',
    ),
    FaqItem(
      question: 'Como faço para conseguir os potes de vidro para doação?',
      answer:
          'Os potes são fornecidos gratuitamente pelo banco de leite parceiro '
          'mais próximo. Você pode retirá-los no ponto de coleta ou solicitar '
          'que sejam enviados na primeira coleta em casa.',
    ),
    FaqItem(
      question: 'Posso tomar remédio e continuar doando?',
      answer:
          'Depende do medicamento. Recomendamos sempre conversar com um '
          'especialista pelo chat antes de continuar as doações enquanto '
          'estiver em tratamento.',
    ),
  ];

  final List<NotificationItem> notifications = const [
    NotificationItem(
      title: 'Lembrete de coleta',
      description: 'Sua coleta está agendada para 21/06 às 14h.',
      time: '10:30',
      icon: 'reminder',
    ),
    NotificationItem(
      title: 'Dica para você',
      description: 'Mantenha uma alimentação equilibrada e beba água.',
      time: 'Ontem',
      icon: 'tip',
    ),
    NotificationItem(
      title: 'Parabéns!',
      description: 'Você alcançou 12 litros doados!',
      time: '2 dias',
      icon: 'success',
    ),
    NotificationItem(
      title: 'Novidade',
      description: 'Novo ponto de coleta disponível perto de você.',
      time: '3 dias',
      icon: 'new',
    ),
    NotificationItem(
      title: 'Acessibilidade',
      description: 'Você ativou a audiodescrição.',
      time: '3 dias',
      icon: 'accessibility',
    ),
  ];

  /// Doações diárias (litros por dia, não acumulado) da última semana.
  final List<MonthlyPoint> weeklyEvolution = const [
    MonthlyPoint(label: 'Seg', liters: 0.3),
    MonthlyPoint(label: 'Ter', liters: 0.5),
    MonthlyPoint(label: 'Qua', liters: 0.0),
    MonthlyPoint(label: 'Qui', liters: 0.6),
    MonthlyPoint(label: 'Sex', liters: 0.4),
    MonthlyPoint(label: 'Sáb', liters: 0.7),
    MonthlyPoint(label: 'Dom', liters: 0.5),
  ];

  /// Evolução mensal do total acumulado de litros doados (não é a
  /// quantidade doada naquele mês isoladamente, e sim o total corrido até
  /// o fim de cada mês) — por isso o último valor (Jun) bate com o total
  /// exibido no card "Litros doados" (12.1L).
  final List<MonthlyPoint> monthlyEvolution = const [
    MonthlyPoint(label: 'Jan', liters: 4.2),
    MonthlyPoint(label: 'Fev', liters: 5.8),
    MonthlyPoint(label: 'Mar', liters: 6.1),
    MonthlyPoint(label: 'Abr', liters: 8.4),
    MonthlyPoint(label: 'Mai', liters: 9.9),
    MonthlyPoint(label: 'Jun', liters: 12.1),
  ];

  /// Como a doadora está no programa há apenas 5 meses, o recorte "Ano"
  /// mostra o total acumulado (mesma métrica do card "Litros doados") ao
  /// final de cada trimestre já concluído de 2026: T1 fecha em março (igual
  /// ao valor acumulado de março na visão mensal) e T2 fecha em junho, com
  /// o total atual de 12.1 litros.
  final List<MonthlyPoint> yearlyEvolution = const [
    MonthlyPoint(label: '1º trim.', liters: 6.1),
    MonthlyPoint(label: '2º trim.', liters: 12.1),
  ];

  List<ImpactStat> get impactRadarStats => const [
        ImpactStat(label: 'Volume\ndoado', value: 80, displayValue: '80%'),
        ImpactStat(label: 'Constância', value: 65, displayValue: '65%'),
        ImpactStat(
            label: 'Tempo como\ndoadora', value: 55, displayValue: '5 meses'),
        ImpactStat(
            label: 'Pontos de\ncoleta', value: 40, displayValue: '2 usados'),
        ImpactStat(
            label: 'Engajamento\nno app', value: 90, displayValue: '90%'),
      ];

  /// Doações do mês de junho, dia a dia. A soma bate com o incremento real
  /// de junho na visão mensal do impacto (12.1 acumulado em jun - 9.9
  /// acumulado em mai = 2.2L), então o "Histórico de doações" fica
  /// consistente com o total de 12.1L mostrado nas outras telas.
  final List<DonationDay> juneDonationDays = [
    DonationDay(date: DateTime(2026, 6, 2), liters: 0.3),
    DonationDay(date: DateTime(2026, 6, 5), liters: 0.2),
    DonationDay(date: DateTime(2026, 6, 9), liters: 0.3),
    DonationDay(date: DateTime(2026, 6, 13), liters: 0.3),
    DonationDay(date: DateTime(2026, 6, 17), liters: 0.2),
    DonationDay(date: DateTime(2026, 6, 21), liters: 0.3),
    DonationDay(date: DateTime(2026, 6, 25), liters: 0.3),
    DonationDay(date: DateTime(2026, 6, 29), liters: 0.3),
  ];

  final List<String> quickChatQuestions = const [
    'Como armazenar o leite?',
    'Posso tomar remédio?',
    'Como funciona a coleta?',
  ];

  final List<ChatMessage> chatHistory = [
    ChatMessage(
      text: 'Olá! Sou o assistente virtual do LacVita. '
          'Como posso te ajudar hoje?',
      fromUser: false,
    ),
  ];

  /// Simula uma resposta simples do assistente virtual com base em
  /// palavras-chave da pergunta do usuário.
  String botReply(String question) {
    final q = question.toLowerCase();
    if (q.contains('armazenar')) {
      return 'Guarde o leite em vidro esterilizado, identificado com data e '
          'hora, e mantenha na geladeira por até 12h ou congelado por até '
          '15 dias.';
    }
    if (q.contains('remédio') || q.contains('remedio')) {
      return 'Depende do medicamento. Me conta qual remédio você está '
          'tomando, ou se preferir posso te conectar com um especialista.';
    }
    if (q.contains('coleta')) {
      return 'Você pode agendar uma coleta em casa ou levar seu leite a um '
          'ponto de coleta parceiro. Quer que eu abra o agendamento agora?';
    }
    if (q.contains('pote') || q.contains('vidro')) {
      return 'Os potes de vidro são fornecidos gratuitamente pelo banco de '
          'leite parceiro mais próximo de você.';
    }
    return 'Entendi! Se preferir uma resposta mais detalhada, posso te '
        'conectar com um de nossos especialistas pelo WhatsApp.';
  }
}
