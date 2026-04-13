import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static Future<void> initialize() {
    return dotenv.load(fileName: ".env");
  }

  static String bannerId = dotenv.get('BANNER_ID', fallback: 'No BANNER_ID');

  static String imageSelectorId = dotenv.get('IMAGE_SELECTION_ID', fallback: 'No IMAGE_SELECTION_ID');

  static String gamerScreenId = dotenv.get(
    'GAMER_SCREEN_ID',
    fallback: 'No GAMER_SCREEN_ID',
  );

  static String rewardedId = dotenv.get('REWARD_ID', fallback: 'No REWARD_ID');

  static String uniqueName = dotenv.get(
    'uniqueName',
    fallback: 'No uniqueName',
  );
}
