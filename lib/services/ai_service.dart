import 'dart:math';

import '../mock_data.dart';
import '../models.dart';

/// Simula o comportamento de um assistente com IA (respostas + resumo
/// automático de conversa) usando 100% lógica local, sem chamadas de rede
/// e sem nenhuma dependência externa. Pensado para demonstrações: não tem
/// custo, não depende de internet/chave de API, e não pode falhar durante
/// uma apresentação.
///
/// Se no futuro quiserem plugar uma IA de verdade (ex.: API da Claude),
/// basta trocar a implementação de `reply` e `summarizeForSpecialist` por
/// uma chamada HTTP, mantendo a mesma assinatura usada em `chat_screen.dart`.
class AiService {
  AiService._();
  static final AiService instance = AiService._();

  /// Nesta versão de demonstração o assistente é sempre simulado.
  bool get isConfigured => false;

  /// Gera a próxima resposta do assistente a partir do histórico da
  /// conversa. Um pequeno atraso simula o tempo de "pensar" de uma IA real.
  Future<String> reply(List<ChatMessage> history) async {
    if (history.isEmpty) return MockData.instance.botReply('');
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(400)));
    return MockData.instance.botReply(history.last.text);
  }

  /// Gera um resumo estruturado da conversa com o assistente, pensado para
  /// ser lido rapidamente por um especialista humano no momento em que a
  /// doadora pede para falar com alguém (aba "Especialista"). Isso evita
  /// que a doadora precise repetir tudo o que já contou para o assistente.
  Future<String> summarizeForSpecialist(List<ChatMessage> history) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final userMessages = history.where((m) => m.fromUser).map((m) => m.text).toList();
    if (userMessages.isEmpty) {
      return 'Você ainda não trocou mensagens com o assistente antes de '
          'pedir para falar com um especialista.';
    }

    final topics = _detectTopics(userMessages);
    final buffer = StringBuffer();
    buffer.writeln('- Motivo do contato: '
        '${topics.isEmpty ? "dúvida geral sobre doação" : topics.join(", ")}.');
    buffer.writeln('- A doadora trocou ${userMessages.length} '
        'mensagem(ns) com o assistente antes de pedir apoio humano.');
    buffer.writeln('- Última pergunta feita ao assistente: '
        '"${userMessages.last}"');
    buffer.write('- Pendência: confirmar com a doadora se a resposta '
        'automática foi suficiente ou se o caso precisa de avaliação '
        'clínica.');
    return buffer.toString();
  }

  /// Identifica, por palavra-chave, os assuntos que a doadora já tocou no
  /// chat — mesma lógica usada em `MockData.botReply`, reaproveitada aqui
  /// para deixar o resumo mais parecido com um resumo gerado por IA real.
  List<String> _detectTopics(List<String> messages) {
    final joined = messages.join(' ').toLowerCase();
    final topics = <String>[];
    if (joined.contains('armazenar')) topics.add('armazenamento do leite');
    if (joined.contains('remédio') || joined.contains('remedio')) {
      topics.add('uso de medicamentos');
    }
    if (joined.contains('coleta')) topics.add('agendamento de coleta');
    if (joined.contains('pote') || joined.contains('vidro')) {
      topics.add('potes de coleta');
    }
    return topics;
  }
}
