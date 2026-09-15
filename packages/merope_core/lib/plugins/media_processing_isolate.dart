import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

/// MediaProcessingIsolate V5 - Steganographic Shield & Phantom Layer.
class MediaProcessingIsolate {

  static Future<void> processWithStego(Uint8List mediaBytes, Uint8List hiddenData) async {
    // This offloads to a dedicated Isolate for pixel-level manipulation
    await Isolate.run(() => _steganographicInject(mediaBytes, hiddenData));
  }

  /// LSB Steganography Mechanic:
  /// Embeds [hiddenData] into the least significant bits of [mediaBytes].
  /// This makes the metadata invisible to visual inspection and standard headers.
  static Uint8List _steganographicInject(Uint8List mediaBytes, Uint8List hiddenData) {
    // 1. Data length verification
    if (hiddenData.length * 8 > mediaBytes.length) {
      throw Exception("Steganographic capacity exceeded");
    }

    final Uint8List output = Uint8List.fromList(mediaBytes);

    // 2. Bitwise injection logic
    int mediaOffset = 0;
    for (int i = 0; i < hiddenData.length; i++) {
      int byte = hiddenData[i];
      for (int bit = 0; bit < 8; bit++) {
        int lsb = (byte >> bit) & 1;
        // Modify the LSB of the media byte
        output[mediaOffset] = (output[mediaOffset] & ~1) | lsb;
        mediaOffset++;
      }
    }

    return output;
  }

  /// Extracts hidden signals from a phantom-layered media file.
  static Uint8List extractStego(Uint8List mediaBytes, int expectedLength) {
    final Uint8List result = Uint8List(expectedLength);
    int mediaOffset = 0;

    for (int i = 0; i < expectedLength; i++) {
      int byte = 0;
      for (int bit = 0; bit < 8; bit++) {
        int lsb = mediaBytes[mediaOffset] & 1;
        byte |= (lsb << bit);
        mediaOffset++;
      }
      result[i] = byte;
    }

    return result;
  }
}
