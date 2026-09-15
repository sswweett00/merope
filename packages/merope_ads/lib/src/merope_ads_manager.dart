import 'ad_provider.dart';

class MeropeAds {
  static final MeropeAds _instance = MeropeAds._internal();
  factory MeropeAds() => _instance;
  MeropeAds._internal();

  AdProvider? _provider;
  bool _isInitialized = false;

  Future<void> initialize(AdProvider provider) async {
    if (_isInitialized) return;
    _provider = provider;
    await _provider!.initialize();
    _isInitialized = true;
  }

  AdProvider get provider {
    if (!_isInitialized || _provider == null) {
      throw StateError('MeropeAds is not initialized. Call initialize() first.');
    }
    return _provider!;
  }

  bool get isInitialized => _isInitialized;
}
