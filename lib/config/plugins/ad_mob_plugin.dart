import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobPlugin {
  static Future<void> initialize() {
    return MobileAds.instance.initialize();
  }
}
