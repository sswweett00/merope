import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AetherGuardStream - Domain-specific Live Stream & Video Protection Subsystem.
///
/// Features:
/// - Dynamic DRM Token Validation & Timestamped Session Nonce Rotation
/// - Dynamic Per-Viewer Watermarking Metadata Engine
/// - Stream Anti-Interception & WebRTC Peer Identity Protection
/// - Encrypted Chunk Signature Verification
class AetherGuardStream {
  /// Generates a dynamic DRM stream session token for a given stream and viewer.
  static AetherStreamToken generateStreamToken({
    required String streamId,
    required String viewerId,
    required String secretKey,
    Duration validDuration = const Duration(minutes: 15),
  }) {
    final expiresAtMs = DateTime.now().add(validDuration).millisecondsSinceEpoch;
    final nonceHex = _generateNonceHex();

    final payloadToSign = '$streamId:$viewerId:$expiresAtMs:$nonceHex';
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final signatureHex = hmac.convert(utf8.encode(payloadToSign)).toString();

    final dynamicWatermarkCode = _computeDynamicWatermark(viewerId, streamId, nonceHex);

    return AetherStreamToken(
      streamId: streamId,
      viewerId: viewerId,
      tokenSignatureHex: signatureHex,
      nonceHex: nonceHex,
      expiresAtMs: expiresAtMs,
      dynamicWatermarkCode: dynamicWatermarkCode,
    );
  }

  /// Validates an incoming stream token and checks expiration and authenticity.
  static bool validateStreamToken({
    required AetherStreamToken token,
    required String secretKey,
  }) {
    if (DateTime.now().millisecondsSinceEpoch > token.expiresAtMs) {
      return false; // Token expired
    }

    final payloadToSign = '${token.streamId}:${token.viewerId}:${token.expiresAtMs}:${token.nonceHex}';
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final expectedSig = hmac.convert(utf8.encode(payloadToSign)).toString();

    return expectedSig == token.tokenSignatureHex;
  }

  /// Verifies a media segment/chunk signature to prevent stream tamper or interception.
  static bool verifyChunkIntegrity({
    required Uint8List chunkBytes,
    required String chunkSignatureHex,
    required String streamId,
    required int sequenceNumber,
    required String sessionSecret,
  }) {
    final hmac = Hmac(sha256, utf8.encode(sessionSecret));
    final chunkHeader = utf8.encode('$streamId:$sequenceNumber:');
    final combined = Uint8List.fromList(chunkHeader + chunkBytes);

    final expected = hmac.convert(combined).toString();
    return expected == chunkSignatureHex;
  }

  static String _computeDynamicWatermark(String viewerId, String streamId, String nonce) {
    final raw = '$viewerId@$streamId#$nonce';
    final hash = sha256.convert(utf8.encode(raw)).toString();
    return hash.substring(0, 12).toUpperCase();
  }

  static String _generateNonceHex() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}

/// Dynamic DRM Stream Authorization Token structure.
class AetherStreamToken {
  final String streamId;
  final String viewerId;
  final String tokenSignatureHex;
  final String nonceHex;
  final int expiresAtMs;
  final String dynamicWatermarkCode;

  const AetherStreamToken({
    required this.streamId,
    required this.viewerId,
    required this.tokenSignatureHex,
    required this.nonceHex,
    required this.expiresAtMs,
    required this.dynamicWatermarkCode,
  });

  Map<String, dynamic> toJson() => {
        'stream_id': streamId,
        'viewer_id': viewerId,
        'token_signature_hex': tokenSignatureHex,
        'nonce_hex': nonceHex,
        'expires_at_ms': expiresAtMs,
        'watermark_code': dynamicWatermarkCode,
      };

  factory AetherStreamToken.fromJson(Map<String, dynamic> json) {
    return AetherStreamToken(
      streamId: json['stream_id'] as String? ?? '',
      viewerId: json['viewer_id'] as String? ?? '',
      tokenSignatureHex: json['token_signature_hex'] as String? ?? '',
      nonceHex: json['nonce_hex'] as String? ?? '',
      expiresAtMs: json['expires_at_ms'] as int? ?? 0,
      dynamicWatermarkCode: json['watermark_code'] as String? ?? '',
    );
  }
}

class AetherGuardStreamNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  AetherStreamToken generateToken({
    required String streamId,
    required String viewerId,
    required String secretKey,
  }) {
    return AetherGuardStream.generateStreamToken(
      streamId: streamId,
      viewerId: viewerId,
      secretKey: secretKey,
    );
  }

  bool validateToken({
    required AetherStreamToken token,
    required String secretKey,
  }) {
    return AetherGuardStream.validateStreamToken(
      token: token,
      secretKey: secretKey,
    );
  }
}

final aetherGuardStreamProvider =
    AsyncNotifierProvider<AetherGuardStreamNotifier, void>(AetherGuardStreamNotifier.new);
