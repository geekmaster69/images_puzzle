int calculateStars(int movs, int segs, int size) {
  // Definimos un objetivo de movimientos basado en la dificultad
  // Ejemplo: 3x3 -> 30 movs, 4x4 -> 80 movs, 5x5 -> 150 movs
  int targetMovs = size * size * (size == 3 ? 4 : 6);
  int targetTime = size * size * (size == 3 ? 5 : 8);

  if (movs <= targetMovs && segs <= targetTime) return 5;
  if (movs <= targetMovs * 1.5 && segs <= targetTime * 1.5) return 4;
  if (movs <= targetMovs * 2 && segs <= targetTime * 2) return 3;
  if (movs <= targetMovs * 3 && segs <= targetTime * 3) return 2;
  return 1;
}