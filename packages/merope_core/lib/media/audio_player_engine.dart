import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioTrackInfo {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;
  final List<String> lyrics;

  const AudioTrackInfo({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
    required this.lyrics,
  });
}

class AudioPlayerState {
  final AudioTrackInfo? currentTrack;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final List<AudioTrackInfo> queue;
  final int queueIndex;

  const AudioPlayerState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.queue = const [],
    this.queueIndex = 0,
  });

  AudioPlayerState copyWith({
    AudioTrackInfo? currentTrack,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    List<AudioTrackInfo>? queue,
    int? queueIndex,
  }) {
    return AudioPlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      queue: queue ?? this.queue,
      queueIndex: queueIndex ?? this.queueIndex,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(const AudioPlayerState());

  void playTrack(AudioTrackInfo track) {
    state = state.copyWith(
      currentTrack: track,
      isPlaying: true,
      position: Duration.zero,
      duration: track.duration,
    );
  }

  void togglePlayPause() {
    if (state.currentTrack == null) return;
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void seek(Duration position) {
    state = state.copyWith(position: position);
  }

  void nextTrack() {
    if (state.queue.isEmpty) return;
    final nextIndex = (state.queueIndex + 1) % state.queue.length;
    playTrack(state.queue[nextIndex]);
    state = state.copyWith(queueIndex: nextIndex);
  }

  void previousTrack() {
    if (state.queue.isEmpty) return;
    final prevIndex = (state.queueIndex - 1 + state.queue.length) % state.queue.length;
    playTrack(state.queue[prevIndex]);
    state = state.copyWith(queueIndex: prevIndex);
  }
}

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});
