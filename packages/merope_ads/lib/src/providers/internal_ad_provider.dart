import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:merope_ui/merope_ui.dart';
import '../ad_provider.dart';

class InternalAdProvider extends AdProvider {
  final Dio _dio;
  final String baseUrl;

  InternalAdProvider({Dio? dio, required this.baseUrl}) : _dio = dio ?? Dio();

  @override
  String get name => 'MeropeInternal';

  @override
  Future<void> initialize() async {
    // Backend connectivity check can be done here
  }

  @override
  Widget buildBannerAd({
    required AdUnit adUnit,
    AdRequest? request,
    AdLoadCallback? callback,
  }) {
    return _InternalBannerWidget(
      adUnit: adUnit,
      request: request,
      callback: callback,
      dio: _dio,
      baseUrl: baseUrl,
    );
  }

  @override
  Future<void> loadInterstitialAd({
    required AdUnit adUnit,
    AdRequest? request,
    AdLoadCallback? callback,
  }) async {
    // Implementation for interstitial
  }

  @override
  Future<void> showInterstitialAd() async {
    // Implementation for interstitial
  }
}

class _InternalBannerWidget extends StatefulWidget {
  final AdUnit adUnit;
  final AdRequest? request;
  final AdLoadCallback? callback;
  final Dio dio;
  final String baseUrl;

  const _InternalBannerWidget({
    required this.adUnit,
    this.request,
    this.callback,
    required this.dio,
    required this.baseUrl,
  });

  @override
  State<_InternalBannerWidget> createState() => _InternalBannerWidgetState();
}

class _InternalBannerWidgetState extends State<_InternalBannerWidget> {
  Map<String, dynamic>? _adData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    try {
      final response =
          await widget.dio.get('${widget.baseUrl}/ads/serve', queryParameters: {
        'ad_unit_id': widget.adUnit.id,
        'interests': widget.request?.keywords?.join(','),
      });

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _adData = response.data[0]; // Simplified: taking first ad
          _isLoading = false;
        });
        widget.callback?.onAdLoaded();
      } else {
        throw Exception('Failed to load ad');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      widget.callback?.onAdFailedToLoad(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const SizedBox(
          height: 50,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    if (_error != null || _adData == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        widget.callback?.onAdClicked();
        // Handle navigation to target link
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            if (_adData!['MediaURL'] != null)
              MeropeImage(
                imageUrl: _adData!['MediaURL'],
                width: 60,
                height: 40,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(4),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _adData!['ContentText'] ?? 'Sponsored',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Text(
                    'Ad • Sponsored',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
