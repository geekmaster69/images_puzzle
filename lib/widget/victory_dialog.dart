import 'package:flutter/material.dart';
import 'package:image_puzzle/services/game_score_service.dart';

import '../config/config.dart';
import '../domain/domain.dart';

void showVictoryDialog(
  BuildContext context, {
  required int moveCount,
  required int seconds,
  required int gridSize,
  required String timeDisplay,
  required String path,
  required int hintsLeft,
}) async {
  int stars = calculateStars(moveCount, seconds, gridSize, hintsLeft);

  NotificationService.scheduleWeeklyReminder();

  final gameScore = GameScore(
    path: path,
    second: seconds,
    tries: moveCount,
    stars: stars,
    griSize: gridSize,
  );
  await GameScoreService().createUpdateGameScore(gameScore);
  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false, // Obliga a interactuar con el diálogo
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "¡Felicidades!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Has armado el rompecabezas"),
          const SizedBox(height: 20),
          // FILA DE ESTRELLAS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 40,
              );
            }),
          ),
          const SizedBox(height: 20),
          Text("⏱ Tiempo: $timeDisplay", style: const TextStyle(fontSize: 18)),
          Text(
            "👣 Movimientos: $moveCount",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          if (stars == 5)
            const Text(
              "¡Eres un maestro! 🏆",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Volver al menú
            },
            child: const Text("VOLVER AL MENÚ"),
          ),
        ),
      ],
    ),
  );
}
