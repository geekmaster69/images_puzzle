int calculateStars(int movs, int segs, int size, int hintsLeft) {
  int targetMovs = (size * size * (size == 3 ? 2 : 4)).toInt();

  int targetTime = (size * size * (size == 3 ? 2.2 : 6)).toInt();

  if (movs <= targetMovs && segs <= targetTime && hintsLeft == 3) {
    return 5;
  }

  if (movs <= targetMovs * 1.3 && segs <= targetTime * 1.3) {
    return 4;
  }

  if (movs <= targetMovs * 1.8 && segs <= targetTime * 1.8) {
    return 3;
  }

  if (movs <= targetMovs * 3 && segs <= targetTime * 3) {
    return 2;
  }

  return 1;
}
