

import 'package:image_puzzle/domain/entities/game_data.dart';

abstract class GameScoreDataSource{

  Future<int> createUpdateGameScore(GameScore gameScore);

  Future<GameScore?> getGameSoreByPath(String path, int griSize);


}