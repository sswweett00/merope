import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// Cross-platform image cache using bounded in-memory storage.
/// The authoritative source remains the network; cache misses are retried normally.
class MeropeImageCacheManager {
  static final MeropeImageCacheManager _instance =
      MeropeImageCacheManager._internal();
  factory MeropeImageCacheManager() => _instance;
  MeropeImageCacheManager._internal();

  final Dio _dio = Dio();
  final Map<String, Uint8List> _memoryCache = {};
  static const int maxMemoryCacheCount = 100;

  String _hashKey(String url) => sha256.convert(utf8.encode(url)).toString();

  Future<Uint8List?> getImageBytes(
    String url, {
    Map<String, String>? headers,
  }) async {
    final key = _hashKey(url);
    final cached = _memoryCache[key];
    if (cached != null) return cached;

    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes, headers: headers),
      );
      if (response.statusCode != 200 || response.data == null) return null;
      final bytes = Uint8List.fromList(response.data!);
      _addToMemoryCache(key, bytes);
      return bytes;
    } catch (_) {
      return null;
    }
  }

  Future<void> prefetchImage(String url) async {
    await getImageBytes(url);
  }

  void _addToMemoryCache(String key, Uint8List bytes) {
    if (_memoryCache.length >= maxMemoryCacheCount) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[key] = bytes;
  }

  Future<void> clearCache() async => _memoryCache.clear();

  Future<int> getCacheSizeInBytes() async =>
      _memoryCache.values.fold<int>(0, (sum, bytes) => sum + bytes.length);
}
