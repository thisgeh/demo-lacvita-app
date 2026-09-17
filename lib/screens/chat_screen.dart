import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../models.dart';
import '../services/ai_service.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  bool _isTyping = false;
  bool _loadingSummary = false;
  String? _specialistSummary;

  List<ChatMessage> get _messages => MockData.instance.chatHistory;

  @override
  void initState() {
    super.initState();
    _tab.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tab.removeListener(_onTabChanged);
    _tab.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Ao abrir a aba "Especialista", regeramos o resumo com base no que já
    // foi conversado até agora — sempre que a aba é aberta, não só na
    // primeira vez, para refletir mensagens trocadas depois da última
    // visita.
    if (_tab.index == 1 && !_loadingSummary) {
      _generateSpecialistSummary();
    }
  }

  Future<void> _generateSpecialistSummary() async {
    setState(() => _loadingSummary = true);
    final summary = await AiService.instance.summarizeForSpecialist(_messages);
    if (!mounted) return;
    setState(() {
      _specialistSummary = summary;
      _loadingSummary = false;
    });
  }

  void _send([String? preset]) {
    final text = preset ?? _inputCtrl.text.trim();
    if (text.isEmpty || _isTyping) return;
    setState(() {
      _messages.add(ChatMessage(text: text, fromUser: true));
      _inputCtrl.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    AiService.instance.reply(_messages).then((reply) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: reply, fromUser: false));
        _isTyping = false;
      });
      _scrollToBottom();
      // Atualiza o resumo do especialista assim que a conversa muda, em vez
      // de só quando o usuário troca de aba — assim ele já está em dia se
      // a doadora for direto para "Especialista" logo em seguida.
      _generateSpecialistSummary();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: _AiStatusBadge(isConfigured: AiService.instance.isConfigured)),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.blue,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.blue,
          tabs: const [Tab(text: 'Assistente'), Tab(text: 'Especialista')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [_buildAssistant(), _buildEspecialista()],
      ),
    );
  }

  Widget _buildAssistant() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= _messages.length) {
                  return const _TypingBubble();
                }
                return _Bubble(message: _messages[i]);
              },
            ),
          ),
          if (_messages.length <= 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MockData.instance.quickChatQuestions
                    .map((q) => ActionChip(
                          label: Text(q),
                          backgroundColor: AppColors.blueLight,
                          side: BorderSide.none,
                          labelStyle: const TextStyle(color: AppColors.blue),
                          onPressed: () => _send(q),
                        ))
                    .toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    decoration: const InputDecoration(hintText: 'Digite sua mensagem...'),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: _isTyping ? null : () => _send(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEspecialista() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
              child: const Icon(Icons.support_agent_rounded, size: 40, color: AppColors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'Você será direcionado ao WhatsApp para falar com um de nossos especialistas',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.navy),
            ),
            const SizedBox(height: 14),
            const Text('Segunda a Sábado, das 8h às 17h',
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 4),
            const Text('Atendimento seguro e acolhedor',
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 24),
            _SpecialistSummaryCard(
              loading: _loadingSummary,
              summary: _specialistSummary,
            ),
            const SizedBox(height: 24),
            const Text('Ao continuar você será direcionado ao aplicativo do WhatsApp',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Abrindo WhatsApp com o resumo da conversa (simulado)...'),
                  ),
                );
              },
              icon: const Icon(Icons.chat_rounded),
              label: const Text('Conversar no WhatsApp'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _tab.animateTo(0),
              child: const Text('Agora não'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pequeno selo indicando se o assistente está usando a IA da Claude de
/// verdade (chave de API configurada no build) ou o modo offline simulado.
class _AiStatusBadge extends StatelessWidget {
  final bool isConfigured;
  const _AiStatusBadge({required this.isConfigured});

  @override
  Widget build(BuildContext context) {
    final color = isConfigured ? AppColors.success : AppColors.blue;
    final label = isConfigured ? 'IA conectada' : 'Assistente simulado';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Card exibido na aba "Especialista" com o resumo gerado por IA da
/// conversa da doadora com o assistente virtual, para agilizar o
/// atendimento humano.
class _SpecialistSummaryCard extends StatelessWidget {
  final bool loading;
  final String? summary;

  const _SpecialistSummaryCard({required this.loading, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.blue),
              SizedBox(width: 8),
              Text(
                'Resumo gerado por IA para o especialista',
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.blue),
                  ),
                  SizedBox(width: 10),
                  Text('Resumindo sua conversa...', style: TextStyle(color: AppColors.textGrey)),
                ],
              ),
            )
          else
            Text(
              summary ?? 'Nenhuma conversa registrada ainda com o assistente.',
              style: const TextStyle(color: AppColors.textDark, height: 1.4, fontSize: 13),
            ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.blueLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(2),
          ),
        ),
        child: const SizedBox(
          width: 30,
          height: 14,
          child: _TypingDots(),
        ),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_controller.value - i * 0.2) % 1.0;
            final double scale = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale.clamp(0.6, 1.0).toDouble(),
                child: const CircleAvatar(radius: 3, backgroundColor: AppColors.blue),
              ),
            );
          }),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.fromUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.blue : AppColors.blueLight,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 2),
            bottomRight: Radius.circular(isUser ? 2 : 14),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isUser ? Colors.white : AppColors.textDark, height: 1.35),
        ),
      ),
    );
  }
}
