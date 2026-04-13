import 'package:flutter/material.dart';


class PuzzlePiece extends StatelessWidget {
  final String image;
  final int pieceId;
  final int gridSize;

  const PuzzlePiece({
    super.key,
    required this.image,
    required this.pieceId,
    required this.gridSize,
  });

  @override
  Widget build(BuildContext context) {
    int row = pieceId ~/ gridSize;
    int col = pieceId % gridSize;

    // Usamos Alignment para mover la imagen gigante dentro del contenedor pequeño
    // La fórmula (-1.0 a 1.0) mapea la posición de la pieza en la rejilla.
    double alignmentX = -1.0 + (col * 2 / (gridSize - 1));
    double alignmentY = -1.0 + (row * 2 / (gridSize - 1));

    return ClipRect(
      child: FractionallySizedBox(
        widthFactor: gridSize.toDouble(),
        heightFactor: gridSize.toDouble(),
        alignment: Alignment(alignmentX, alignmentY),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}