class GameScore {
  final int? id;
  final String path;
  final int second;
  final int tries;
  final int stars;
  final int griSize;

  GameScore({
    this.id,
    required this.path,
    required this.second,
    required this.tries,
    required this.stars,
    required this.griSize,
  });

  GameScore copyWith({
    int? id,
    String? path,
    int? second,
    int? tries,
    int? stars,
    int? griSize,
  }) {
    return GameScore(
      id: id ?? this.id,
      path: path ?? this.path,
      second: second ?? this.second,
      tries: tries ?? this.tries,
      stars: stars ?? this.stars,
      griSize: griSize ?? this.griSize,
    );
  }
}
