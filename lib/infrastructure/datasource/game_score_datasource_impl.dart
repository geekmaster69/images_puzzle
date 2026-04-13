import 'package:image_puzzle/infrastructure/infrastructure.dart';

import '../../config/database/data_base.dart';
import '../../domain/domain.dart';

class GameScoreDatasourceImpl implements GameScoreDataSource {
  final db = DatabaseHelper().db;
  @override
  Future<int> createUpdateGameScore(GameScore gameScore) async {
    try {
      return await db.insert(
        gameScoreTable,
        GameScoreModelX.fromEntity(gameScore).toMap(),
        conflictAlgorithm: .replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GameScore?> getGameSoreByPath(String path, int griSize) async {
    try {
      final results = await db.query(
        gameScoreTable,
        where: 'path = ? AND griSize = ?',
        whereArgs: [path, griSize],
        limit: 1,
      );

      if (results.isEmpty) return null;

      return GameScoreModel.fromMap(results.first).toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
