const String gameScoreTable = 'gameScoreTable';

class GameScoreModel {
  final int? id;
  final String path;
  final int second;
  final int tries;
  final int stars;
  final int griSize;

  GameScoreModel({
    required this.id,
    required this.path,
    required this.second,
    required this.tries,
    required this.stars,
    required this.griSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'path': path,
      'second': second,
      'tries': tries,
      'stars': stars,
      'griSize': griSize,
    };
  }

  factory GameScoreModel.fromMap(Map<String, dynamic> map) {
    return GameScoreModel(
      id: map['id'] as int,
      path: map['path'] as String,
      second: map['second'] as int,
      tries: map['tries'] as int,
      stars: map['stars'] as int,
      griSize: map['griSize'] as int,
    );
  }

  static String get createTable =>
      '''
CREATE TABLE $gameScoreTable(
 id INTEGER PRIMARY KEY,
 path TEXT,
 second INTEGER,
 tries INTEGER,
 stars INTEGER,
 griSize INTEGER

)
''';
}
