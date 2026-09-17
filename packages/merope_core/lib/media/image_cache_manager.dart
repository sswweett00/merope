import 'package:crypto/crypto.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

/// Offline-first Image Cache Manager for Merope.
/// Handles high-speed disk caching, memory caching, prefetching, and eviction.
class MeropeImageCacheManager {
  static final MeropeImageCacheManager _instance =
      MeropeImageCacheManager._internal();
  factory MeropeImageCacheManager() => _instance;
  MeropeImageCacheManager._internal();

  final Dio _dio = Dio();
  Directory? _cacheDir;
  final Map<String, Uint8List> _memoryCache = {};
  static const int maxMemoryCacheCount = 100;

  Future<Directory> get _directory async {
    if (_cacheDir != null) return _cacheDir!;
    final tempDir = await getTemporaryDirectory();
    _cacheDir = Directory('${tempDir.path}/merope_image_cache');
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
    return _cacheDir!;
  }

  String _hashKey(String url) {
    return sha256.convert(utf8.encode(url)).toString();
  }

  /// Get image bytes from memory cache, local disk cache, or download via HTTP.
  Future<Uint8List?> getImageBytes(String url,
      {Map<String, String>? headers}) async {
    final key = _hashKey(url);

    // 1. Memory Cache
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key];
    }

    // 2. Disk Cache
    final dir = await _directory;
    final file = File('${dir.path}/$key');
    if (await file.exists()) {
      try {
        final bytes = await file.readAsBytes();
        _addToMemoryCache(key, bytes);
        return bytes;
      } catch (_) {
        // Fallback to fetch if read fails
      }
    }

    // 3. Network Fetch
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: headers,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        await file.writeAsBytes(bytes, flush: true);
        _addToMemoryCache(key, bytes);
        return bytes;
      }
    } catch (e) {
      // Return null on failure to allow retry widget
    }

    return null;
  }

  /// Prefetch image into disk and memory cache ahead of time.
  Future<void> prefetchImage(String url) async {
    await getImageBytes(url);
  }

  /// Get cached file path if file exists locally.
  Future<File?> getCachedFile(String url) async {
    final key = _hashKey(url);
    final dir = await _directory;
    final file = File('${dir.path}/$key');
    return await file.exists() ? file : null;
  }

  void _addToMemoryCache(String key, Uint8List bytes) {
    if (_memoryCache.length >= maxMemoryCacheCount) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[key] = bytes;
  }

  /// Clear both memory and disk caches.
  Future<void> clearCache() async {
    _memoryCache.clear();
    final dir = await _directory;
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      await dir.create(recursive: true);
    }
  }

  /// Calculate size of cached images on disk in bytes.
  Future<int> getCacheSizeInBytes() async {
    final dir = await _directory;
    if (!await dir.exists()) return 0;
    int total = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }
}
