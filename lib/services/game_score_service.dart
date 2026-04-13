import 'package:image_puzzle/domain/domain.dart';
import 'package:image_puzzle/infrastructure/infrastructure.dart';

class GameScoreService {
  final GameScoreRepository repository = GameScoreRepositoryImpl(
    GameScoreDatasourceImpl(),
  );

  Future<void> createUpdateGameScore(GameScore gameScore) {
    return repository.createUpdateGameScore(gameScore);
  }

  Future<GameScore?> getGameScoreByPath(String path, int griSize) {
    return repository.getGameSoreByPath(path, griSize);
  }
}
