import 'package:flutter/material.dart';
import 'package:image_puzzle/services/game_score_service.dart';
import 'package:image_puzzle/widget/score_card.dart';

import '../domain/domain.dart';

class GameScoreWidget extends StatelessWidget {
  final String path;
  final int griSize;
  final GameScoreService scoreService = GameScoreService();

  GameScoreWidget({super.key, required this.path, required this.griSize});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameScore?>(
      // Llamamos al método del servicio que conecta con el repositorio y sqflite
      future: scoreService.getGameScoreByPath(path, griSize),
      builder: (context, snapshot) {
        // 1. Mientras carga...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox.shrink());
        }

        // 2. Si hubo un error (ej. tabla no existe o error de casteo)
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // 3. Si no hay datos (snapshot.data es null)
        if (!snapshot.hasData) {
          return const Center(child: Text('No hay puntajes registrados.'));
        }

        // 4. Cuando el dato llega con éxito
        final score = snapshot.data;

        return (score == null)
            ? SizedBox.shrink()
            : GameScoreCard(score: score);
      },
    );
  }
}
