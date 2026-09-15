import 'package:flutter/material.dart';
import '../ad_provider.dart';
import '../merope_ads_manager.dart';

class MeropeBannerAd extends StatelessWidget {
  final AdUnit adUnit;
  final AdRequest? request;
  final AdLoadCallback? callback;

  const MeropeBannerAd({
    super.key,
    required this.adUnit,
    this.request,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    if (!MeropeAds().isInitialized) {
      return const SizedBox.shrink();
    }

    return MeropeAds().provider.buildBannerAd(
      adUnit: adUnit,
      request: request,
      callback: callback,
    );
  }
}
