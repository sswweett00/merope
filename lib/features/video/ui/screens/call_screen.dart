import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../logic/webrtc_provider.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import 'package:merope_core/utils/merope_acoustics.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String remoteUserId;
  final String remoteUserName;

  const CallScreen({
    super.key,
    required this.remoteUserId,
    required this.remoteUserName,
  });

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initRenderers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(webRTCControllerProvider.notifier).startCall(widget.remoteUserId);
    });
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(webRTCControllerProvider.notifier);

    if (notifier.localStream != null) {
      _localRenderer.srcObject = notifier.localStream;
    }
    if (notifier.remoteStream != null) {
      _remoteRenderer.srcObject = notifier.remoteStream;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote Video
          Positioned.fill(
            child: RTCVideoView(_remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
          ),

          // Local Video (Small Overlay)
          Positioned(
            top: 48,
            right: 16,
            width: 120,
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RTCVideoView(_localRenderer, mirror: true, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
            ),
          ),

          // Caller Info
          Positioned(
            top: 64,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.remoteUserName,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Ongoing Call",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          // Controls
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ControlButton(
                  icon: Icons.flip_camera_ios_outlined,
                  color: Colors.white24,
                  onTap: () => MeropeHaptics.trigger(MeropeTokens.hapticSelection),
                ),
                const SizedBox(width: 16),
                _ControlButton(icon: Icons.mic_off, color: Colors.white24, onTap: () {}),
                const SizedBox(width: 24),
                _ControlButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  size: 64,
                  onTap: () {
                    notifier.hangUp();
                    MeropeAcoustics.trigger(AcousticEffect.error);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 24),
                _ControlButton(icon: Icons.videocam_off, color: Colors.white24, onTap: () {}),
                const SizedBox(width: 16),
                _ControlButton(
                  icon: Icons.screen_share_outlined,
                  color: Colors.white24,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Starting encrypted screenshare...'))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.color,
    this.size = 56,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
