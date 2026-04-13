import 'package:image_puzzle/domain/domain.dart';
import 'package:image_puzzle/infrastructure/infrastructure.dart';

extension GameScoreModelX on GameScoreModel {
  GameScore toEntity() => GameScore(
    path: path,
    second: second,
    tries: tries,
    stars: stars,
    griSize: griSize,
  );

  static GameScoreModel fromEntity(GameScore gameScore) {
    return GameScoreModel(
      id: gameScore.id,
      path: gameScore.path,
      second: gameScore.second,
      tries: gameScore.tries,
      stars: gameScore.stars,
      griSize: gameScore.griSize
    );
  }
}
