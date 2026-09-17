import 'package:flutter/material.dart';
import '../theme.dart';
import '../screens/home_screen.dart';
import '../screens/coletas_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/impacto_screen.dart';
import '../screens/perfil_screen.dart';

/// Shell principal do app logado, com a barra inferior
/// Início | Coletas | Chat | Impacto | Perfil, igual ao protótipo.
class AppShell extends StatefulWidget {
  final int initialIndex;
  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _index = widget.initialIndex;

  final _items = const [
    _NavItem('Início', Icons.home_rounded),
    _NavItem('Coletas', Icons.local_shipping_rounded),
    _NavItem('Chat', Icons.chat_bubble_rounded),
    _NavItem('Impacto', Icons.insights_rounded),
    _NavItem('Perfil', Icons.person_rounded),
  ];

  void goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    // Instâncias novas (não-const) a cada build: garante que a Home releia
    // os dados mockados mais recentes (ex.: um agendamento feito em outra
    // aba) sempre que o usuário troca de aba, em vez de ficar presa na
    // primeira versão construída.
    final screens = [
      HomeScreen(),
      ColetasScreen(),
      ChatScreen(),
      ImpactoScreen(),
      PerfilScreen(),
    ];

    return Scaffold(
      body: AppShellController(
        goTo: goTo,
        activeIndex: _index,
        child: IndexedStack(index: _index, children: screens),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final selected = i == _index;
              final item = _items[i];
              return InkWell(
                onTap: () => goTo(i),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: selected ? AppColors.blue : AppColors.textGrey,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          color: selected ? AppColors.blue : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem(this.label, this.icon);
}

/// Helper para trocar de aba a partir de telas filhas (ex: botão "Quero Doar"
/// na Home leva para a aba Coletas) e para telas saberem quando a própria
/// aba ficou visível (ex: reiniciar uma animação de entrada).
class AppShellController extends InheritedWidget {
  final void Function(int index) goTo;
  final int activeIndex;
  const AppShellController({
    super.key,
    required this.goTo,
    required this.activeIndex,
    required super.child,
  });

  static AppShellController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShellController>();

  @override
  bool updateShouldNotify(covariant AppShellController oldWidget) =>
      oldWidget.activeIndex != activeIndex;
}
