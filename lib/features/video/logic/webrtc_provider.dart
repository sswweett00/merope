import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebRTCController extends AsyncNotifier<void> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  @override
  FutureOr<void> build() async {
    ref.onDispose(() {
      _localStream?.dispose();
      _peerConnection?.dispose();
    });
  }

  Future<void> startCall(String remoteUserId) async {
    final localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'},
    });
    _localStream = localStream;

    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };
    _peerConnection = await createPeerConnection(config);

    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        ref.invalidateSelf();
      }
    };

    final RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
  }

  MediaStream? get localStream => _localStream;
  MediaStream? get remoteStream => _remoteStream;

  Future<void> hangUp() async {
    await _localStream?.dispose();
    await _peerConnection?.close();
    _peerConnection = null;
    _localStream = null;
    _remoteStream = null;
    ref.invalidateSelf();
  }
}

final webRTCControllerProvider = AsyncNotifierProvider<WebRTCController, void>(WebRTCController.new);
