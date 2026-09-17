import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/database/database_provider.dart';
import '../domain/models/media_models.dart';
import '../data/repository/media_repository.dart';

final mediaRepositoryProvider = Provider<IMediaRepository>((ref) {
  final db = ref.watch(meropeDatabaseProvider);
  return DriftMediaRepository(db);
});

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(const AudioPlayerState());

  void playTrack(MeropeTrack track) {
    state = state.copyWith(
      currentTrack: track,
      status: PlaybackState.playing,
      position: Duration.zero,
      duration: Duration(seconds: track.durationSeconds),
    );
    // In a real app, interface with media_kit or audioplayers
  }

  void togglePlay() {
    if (state.status == PlaybackState.playing) {
      state = state.copyWith(status: PlaybackState.paused);
    } else {
      state = state.copyWith(status: PlaybackState.playing);
    }
  }

  void setQueue(List<MeropeTrack> queue) {
    state = state.copyWith(queue: queue);
  }

  void next() {
    if (state.queue.isEmpty) return;
    final currentIndex = state.queue.indexOf(state.currentTrack!);
    if (currentIndex < state.queue.length - 1) {
      playTrack(state.queue[currentIndex + 1]);
    }
  }

  void previous() {
    if (state.queue.isEmpty) return;
    final currentIndex = state.queue.indexOf(state.currentTrack!);
    if (currentIndex > 0) {
      playTrack(state.queue[currentIndex - 1]);
    }
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});

final tracksListProvider = FutureProvider<List<MeropeTrack>>((ref) async {
  final repo = ref.watch(mediaRepositoryProvider);
  return repo.getTracks();
});

final playlistsProvider = FutureProvider<List<MeropePlaylist>>((ref) async {
  final repo = ref.watch(mediaRepositoryProvider);
  return repo.getPlaylists();
});
