import 'package:flutter/widgets.dart';

enum AdType { banner, interstitial, rewarded, native }

class AdUnit {
  final String id;
  final AdType type;
  final Map<String, dynamic>? extras;

  const AdUnit({required this.id, required this.type, this.extras});
}

class AdRequest {
  final List<String>? keywords;
  final Map<String, dynamic>? contentInfo;

  const AdRequest({this.keywords, this.contentInfo});
}

abstract class AdLoadCallback {
  void onAdLoaded();
  void onAdFailedToLoad(String error);
  void onAdOpened() {}
  void onAdClosed() {}
  void onAdClicked() {}
}

abstract class AdProvider {
  String get name;

  Future<void> initialize();

  Widget buildBannerAd({
    required AdUnit adUnit,
    AdRequest? request,
    AdLoadCallback? callback,
  });

  Future<void> loadInterstitialAd({
    required AdUnit adUnit,
    AdRequest? request,
    AdLoadCallback? callback,
  });

  Future<void> showInterstitialAd();
}
