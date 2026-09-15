import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

class MediaCompressionRequest {
  final String sourcePath;
  final String targetPath;
  final int maxWidth;
  final int maxHeight;
  final int quality; // 1-100

  MediaCompressionRequest({
    required this.sourcePath,
    required this.targetPath,
    this.maxWidth = 1920,
    this.maxHeight = 1080,
    this.quality = 80,
  });
}

class MediaCompressionResult {
  final bool success;
  final String outputPath;
  final int originalSize;
  final int compressedSize;
  final int width;
  final int height;
  final String? error;

  MediaCompressionResult({
    required this.success,
    required this.outputPath,
    required this.originalSize,
    required this.compressedSize,
    required this.width,
    required this.height,
    this.error,
  });
}

/// High-Performance Isolate Worker for Image & Media Compression.
class MediaCompressionIsolate {
  /// Offloads heavy image scaling and compression to a separate Isolate.
  static Future<MediaCompressionResult> compressImage(MediaCompressionRequest request) async {
    return await Isolate.run(() async {
      try {
        final sourceFile = File(request.sourcePath);
        if (!await sourceFile.exists()) {
          return MediaCompressionResult(
            success: false,
            outputPath: '',
            originalSize: 0,
            compressedSize: 0,
            width: 0,
            height: 0,
            error: 'Source file does not exist',
          );
        }

        final originalBytes = await sourceFile.readAsBytes();
        final originalSize = originalBytes.length;

        // Decode image header and dimensions using UI codec
        final codec = await ui.instantiateImageCodec(
          originalBytes,
          targetWidth: request.maxWidth > 0 ? request.maxWidth : null,
          targetHeight: request.maxHeight > 0 ? request.maxHeight : null,
        );

        final frame = await codec.getNextFrame();
        final image = frame.image;
        final width = image.width;
        final height = image.height;

        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final compressedBytes = byteData?.buffer.asUint8List() ?? originalBytes;

        final outputFile = File(request.targetPath);
        await outputFile.writeAsBytes(compressedBytes, flush: true);
        final compressedSize = await outputFile.length();

        return MediaCompressionResult(
          success: true,
          outputPath: request.targetPath,
          originalSize: originalSize,
          compressedSize: compressedSize,
          width: width,
          height: height,
        );
      } catch (e) {
        return MediaCompressionResult(
          success: false,
          outputPath: request.sourcePath,
          originalSize: 0,
          compressedSize: 0,
          width: 0,
          height: 0,
          error: e.toString(),
        );
      }
    });
  }

  /// Helper to compress image in place or with automatic temp file.
  static Future<String> compressMedia(String filePath) async {
    final targetPath = '${filePath}_compressed.jpg';
    final result = await compressImage(MediaCompressionRequest(
      sourcePath: filePath,
      targetPath: targetPath,
    ));
    return result.success ? result.outputPath : filePath;
  }
}
