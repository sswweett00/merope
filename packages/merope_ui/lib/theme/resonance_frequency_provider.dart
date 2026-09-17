import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ResonanceEvent {
  signalBroadcast,
  messageSent,
  collectiveJoin,
  reactionBurst
}

class ResonanceFrequency extends Notifier<double> {
  Timer? _decayTimer;

  @override
  double build() {
    ref.onDispose(() => _decayTimer?.cancel());
    return 1.0; // Base frequency (idle)
  }

  void triggerEvent(ResonanceEvent event) {
    double boost = 0.0;
    switch (event) {
      case ResonanceEvent.signalBroadcast:
        boost = 0.5;
        break;
      case ResonanceEvent.messageSent:
        boost = 0.2;
        break;
      case ResonanceEvent.collectiveJoin:
        boost = 0.8;
        break;
      case ResonanceEvent.reactionBurst:
        boost = 0.3;
        break;
    }

    state = (state + boost).clamp(1.0, 3.0);
    _startDecay();
  }

  void _startDecay() {
    _decayTimer?.cancel();
    _decayTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (state > 1.0) {
        state = (state - 0.02).clamp(1.0, 3.0);
      } else {
        timer.cancel();
      }
    });
  }
}

final resonanceFrequencyProvider =
    NotifierProvider<ResonanceFrequency, double>(ResonanceFrequency.new);
