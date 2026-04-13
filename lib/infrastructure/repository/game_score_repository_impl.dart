import '../../domain/domain.dart';

class GameScoreRepositoryImpl implements GameScoreRepository {
  final GameScoreDataSource dataSource;

  GameScoreRepositoryImpl(this.dataSource);

  @override
  Future<int> createUpdateGameScore(GameScore gameScore) {
    return dataSource.createUpdateGameScore(gameScore);
  }

  @override
  Future<GameScore?> getGameSoreByPath(String path, int griSize) {
  return dataSource.getGameSoreByPath(path, griSize);
  }
}
