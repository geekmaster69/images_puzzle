import 'package:flutter/material.dart';

import '../domain/domain.dart';

class GameScoreCard extends StatelessWidget {
  final GameScore score;

  const GameScoreCard({super.key, required this.score});

  // Función para formatear segundos a 00:00
  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // Generador de ranking de estrellas
  Widget _buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < count ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Tiempo formateado
        Column(
          children: [
            Text(
              "Nivel: ${score.griSize}x${score.griSize}",
              style: const TextStyle(fontWeight: .bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Ranking de Estrellas
            _buildStars(score.stars),
          ],
        ),
        _ScoreStat(
          icon: Icons.timer_outlined,
          label: "Tiempo",
          value: _formatTime(score.second),
        ),

        // Movimientos (tries)
        _ScoreStat(
          icon: Icons.fact_check_outlined,
          label: "Movimientos",
          value: "${score.tries}",
        ),
      ],
    );
  }
}

// Widget de apoyo para las estadísticas pequeñas
class _ScoreStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ScoreStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
