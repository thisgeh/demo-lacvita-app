# LacVita — App Flutter (protótipo funcional)

App em Flutter inspirado nas duas referências enviadas:
- `lacvita_meu_impacto_radar.png` (tela "Meu impacto" com radar chart)
- `Anexo_F_Prototipo.pdf` (fluxo completo do app: onboarding, login, home,
  agendamento de coleta, pontos de coleta, chat, impacto, perfil, notificações,
  FAQ e histórico de doações)

## ✨ Novidades: chat com resumo automático + recomendação inteligente de pontos de coleta

Duas features de inovação foram adicionadas ao protótipo original. **Ambas
são 100% simuladas/mockadas** — não usam nenhuma API externa nem dependência
nova, então continuam funcionando totalmente offline, sem custo e sem risco
de falhar numa apresentação:

1. **Assistente virtual com resumo automático para o especialista** — `lib/services/ai_service.dart`
   - O chat (`lib/screens/chat_screen.dart`) responde com um pequeno atraso
     simulado (efeito "digitando...") para parecer mais natural.
   - Ao abrir a aba **"Especialista"**, o app gera automaticamente um
     **resumo da conversa** já tida com o assistente (detectando por
     palavra-chave os assuntos tratados: armazenamento, medicamentos,
     coleta, potes), para o atendente humano não precisar pedir para a
     doadora repetir tudo.
   - Para o resumo aparecer, é preciso primeiro trocar pelo menos uma
     mensagem na aba "Assistente" antes de abrir a aba "Especialista" — sem
     isso, ele mostra um aviso de que ainda não há conversa para resumir.
   - O código já está preparado para, no futuro, trocar essa simulação por
     uma IA real (ex.: API da Claude) sem mudar a tela — bastaria
     reimplementar `reply()` e `summarizeForSpecialist()` em `ai_service.dart`.

2. **Recomendação inteligente de pontos de coleta** — `lib/services/matching_service.dart`
   - A tela **"Pontos de coleta"** (`pontos_coleta_screen.dart`) ordena os
     pontos por um score de compatibilidade (0–100%) combinando: distância
     (mockada, sem GPS real), se o ponto aceita o tipo de coleta que a
     doadora prefere (casa ou entrega), se ela já doou lá antes, e se é
     parceiro oficial.
   - O primeiro da lista ganha o selo **"Recomendado para você"**, com chips
     explicando os motivos da recomendação (ex.: "Ponto mais próximo de
     você", "Você já doou aqui antes").

## Como rodar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install)
instalado (canal stable).

```bash
cd lacvita_app
flutter pub get
flutter run
```

Não há dependências de pacotes de terceiros (pub.dev) — tudo (incluindo os
gráficos de radar e barras, o chat e a recomendação de pontos de coleta) foi
implementado com Dart/Flutter puro, então o `flutter pub get` deve funcionar
mesmo offline na maioria dos casos.

## Fluxo do app

1. **Splash** → **Onboarding** ("Como funciona") → pergunta **Conecta BLH**
   → **Login** (se já cadastrada) ou **Triagem de cadastro** (se nova)
2. **Home**: próxima coleta, ações rápidas (Quero doar / Encontrar ponto),
   resumo de impacto, dica diária, central da saúde (com upload de exames)
   e atalho para o FAQ
3. **Coletas**: agendamento (tipo de coleta, data e hora) + lista de pontos
   de coleta com detalhes
4. **Chat**: assistente virtual (com respostas simuladas por palavra-chave)
   e aba "Especialista" (redirecionamento simulado ao WhatsApp)
5. **Meu Impacto**: cartões de litros doados / bebês alimentados, **radar
   chart** (Volume doado, Constância, Tempo como doadora, Pontos de coleta,
   Engajamento no app) e gráfico de evolução mensal, com atalho para o
   histórico de doações (calendário)
6. **Perfil**: dados da doadora, atalhos e opção de sair (retorna à Splash)

## Estrutura

```
lib/
  main.dart
  theme.dart          # cores e estilos globais
  models.dart         # modelos de dados
  mock_data.dart       # "banco de dados" em memória
  widgets/
    app_shell.dart          # navegação inferior (Início/Coletas/Chat/Impacto/Perfil)
    radar_chart.dart         # radar chart via CustomPainter
    evolution_bar_chart.dart # gráfico de barras via CustomPainter
  services/
    ai_service.dart          # chat simulado + resumo automático p/ especialista
    matching_service.dart    # recomendação inteligente de pontos de coleta
  screens/
    splash_screen.dart
    onboarding_screen.dart
    conecta_blh_screen.dart
    login_screen.dart
    signup_screening_screen.dart
    home_screen.dart
    coletas_screen.dart
    pontos_coleta_screen.dart
    chat_screen.dart
    impacto_screen.dart
    historico_screen.dart
    perfil_screen.dart
    notificacoes_screen.dart
    faq_screen.dart
    upload_exames_screen.dart
```

## Personalizando dados

Para trocar os dados mockados (nome da doadora, litros doados, pontos de
coleta, perguntas do FAQ, notificações, etc.), edite apenas o arquivo
`lib/mock_data.dart` — todas as telas consomem essa fonte única de dados.
