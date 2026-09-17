import '../models.dart';

/// Resultado do matching: um ponto de coleta com sua nota de
/// compatibilidade (0 a 100) e os motivos que explicam a recomendação.
class PointMatch {
  final CollectionPoint point;
  final double score;
  final List<String> reasons;

  const PointMatch({
    required this.point,
    required this.score,
    required this.reasons,
  });

  int get scorePercent => score.round().clamp(0, 100);
}

/// Serviço de recomendação de pontos de coleta.
///
/// Combina distância, tipo de coleta preferido pela doadora, histórico de
/// uso e se o ponto é parceiro oficial em uma nota única de compatibilidade,
/// para sugerir automaticamente o ponto mais adequado — em vez de deixar a
/// doadora comparar uma lista simples manualmente.
class MatchingService {
  MatchingService._();

  static const _weightDistance = 0.40;
  static const _weightType = 0.25;
  static const _weightLoyalty = 0.15;
  static const _weightPartner = 0.20;

  static double _distanceInMeters(String distance) {
    final d = distance.toLowerCase().trim();
    if (d.endsWith('km')) {
      final value = double.tryParse(d.replaceAll('km', '').trim());
      return (value ?? 5.0) * 1000;
    }
    if (d.endsWith('m')) {
      final value = double.tryParse(d.replaceAll('m', '').trim());
      return value ?? 5000;
    }
    return 5000;
  }

  /// Calcula e ordena os pontos de coleta do mais para o menos
  /// recomendado para a [donor] informada.
  static List<PointMatch> rank(Donor donor, List<CollectionPoint> points) {
    if (points.isEmpty) return const [];

    final distances = [for (final p in points) _distanceInMeters(p.distance)];
    final minDistance = distances.reduce((a, b) => a < b ? a : b);
    final maxDistance = distances.reduce((a, b) => a > b ? a : b);
    final range = (maxDistance - minDistance) == 0 ? 1 : maxDistance - minDistance;

    // Se a doadora ainda não tem nenhum agendamento, não há preferência de
    // tipo de coleta ainda — nesse caso o critério de tipo fica neutro
    // (não penaliza nem beneficia nenhum ponto).
    final preference = donor.nextCollectionType?.toLowerCase();
    final prefersHome = preference?.contains('casa') ?? false;
    final hasPreference = preference != null;

    final matches = <PointMatch>[];
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final reasons = <String>[];

      // Distância: quanto mais perto, maior a nota.
      final distScore = 100 - ((distances[i] - minDistance) / range * 100);
      if (distances[i] == minDistance) {
        reasons.add('Ponto mais próximo de você');
      }

      // Compatibilidade com o tipo de coleta que a doadora prefere.
      double typeScore;
      if (!hasPreference) {
        typeScore = 70; // neutro: ainda não sabemos a preferência dela
      } else if (prefersHome && point.offersHomeCollection) {
        typeScore = 100;
        reasons.add('Oferece coleta em casa, como você prefere');
      } else if (!prefersHome && point.offersDropOff) {
        typeScore = 100;
        reasons.add('Aceita entrega no local');
      } else {
        typeScore = 40;
      }

      // Familiaridade: pontos que a doadora já usou reduzem fricção.
      final loyaltyScore = point.pastVisits.clamp(0, 5) / 5 * 100;
      if (point.pastVisits > 0) {
        reasons.add('Você já doou aqui antes');
      }

      // Parceiros oficiais têm estrutura validada pelo programa.
      final isOfficial = point.tag.toLowerCase().contains('oficial');
      final partnerScore = isOfficial ? 100.0 : 60.0;
      if (isOfficial) {
        reasons.add('Parceiro oficial do programa');
      }

      final total = distScore * _weightDistance +
          typeScore * _weightType +
          loyaltyScore * _weightLoyalty +
          partnerScore * _weightPartner;

      matches.add(PointMatch(
        point: point,
        score: total,
        reasons: reasons.take(3).toList(),
      ));
    }

    matches.sort((a, b) => b.score.compareTo(a.score));
    return matches;
  }
}
