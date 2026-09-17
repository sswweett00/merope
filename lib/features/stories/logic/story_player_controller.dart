import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_models/stories/story_model.dart';

class StoryPlayerState {
  final int currentIndex;
  final double progress;
  final bool isPaused;

  const StoryPlayerState(
      {this.currentIndex = 0, this.progress = 0.0, this.isPaused = false});

  StoryPlayerState copyWith(
          {int? currentIndex, double? progress, bool? isPaused}) =>
      StoryPlayerState(
        currentIndex: currentIndex ?? this.currentIndex,
        progress: progress ?? this.progress,
        isPaused: isPaused ?? this.isPaused,
      );
}

class StoryPlayerController
    extends FamilyAsyncNotifier<StoryPlayerState, Story> {
  Timer? _timer;
  static const int _updateIntervalMs = 50;

  @override
  FutureOr<StoryPlayerState> build(Story arg) {
    ref.onDispose(() => _timer?.cancel());
    _startTimer();
    return const StoryPlayerState();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer =
        Timer.periodic(const Duration(milliseconds: _updateIntervalMs), (_) {
      final current = state.value;
      if (current == null || current.isPaused || arg.segments.isEmpty) return;
      final segment = arg.segments[current.currentIndex];
      final durationMs = segment.duration * 1000;
      final newProgress = current.progress + (_updateIntervalMs / durationMs);
      if (newProgress >= 1.0) {
        next();
      } else {
        state = AsyncValue.data(current.copyWith(progress: newProgress));
      }
    });
  }

  void next() {
    final current = state.value;
    if (current == null) return;
    if (current.currentIndex < arg.segments.length - 1) {
      state = AsyncValue.data(current.copyWith(
          currentIndex: current.currentIndex + 1, progress: 0.0));
    } else {
      _timer?.cancel();
      state = AsyncValue.data(current.copyWith(progress: 1.0));
    }
  }

  void previous() {
    final current = state.value;
    if (current == null) return;
    if (current.currentIndex > 0) {
      state = AsyncValue.data(current.copyWith(
          currentIndex: current.currentIndex - 1, progress: 0.0));
    } else {
      state = AsyncValue.data(current.copyWith(progress: 0.0));
    }
  }

  void pause() {
    if (state.hasValue)
      state = AsyncValue.data(state.value!.copyWith(isPaused: true));
  }

  void resume() {
    if (state.hasValue)
      state = AsyncValue.data(state.value!.copyWith(isPaused: false));
  }
}

final storyPlayerControllerProvider =
    AsyncNotifierProviderFamily<StoryPlayerController, StoryPlayerState, Story>(
        StoryPlayerController.new);

extension StoryPlayerAsyncValueCompatibility on AsyncValue<StoryPlayerState> {
  StoryPlayerState get _current => valueOrNull ?? const StoryPlayerState();
  int get currentIndex => _current.currentIndex;
  double get progress => _current.progress;
}
