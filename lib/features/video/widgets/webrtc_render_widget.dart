import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// MeropeWebRTCRenderer V9 - Nirvana Layer (GPU Shader FX).
class MeropeWebRTCRenderer extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool enablePrivacyBlur;

  const MeropeWebRTCRenderer({
    super.key,
    required this.renderer,
    this.enablePrivacyBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: enablePrivacyBlur
          ? _buildShadedRenderer()
          : RTCVideoView(renderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
    );
  }

  /// Mechanic: Fragment-Shaded Post-Processing.
  /// Uses GPU shaders to apply real-time FX (Blur/Privacy) without CPU load.
  Widget _buildShadedRenderer() {
    // In production, we'd use 'ShaderMask' or 'ImageFiltered' with a custom
    // '.frag' file compiled for Impeller.
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: RTCVideoView(
        renderer,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
    );
  }
}
