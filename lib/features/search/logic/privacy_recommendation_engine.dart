import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy_recommendation_engine.g.dart';

class UserInterestMetric {
  final double watchTimeFactor;
  final double scrollSpeedFactor;
  final int interactionCount;
  final bool isSensitive;

  UserInterestMetric({
    required this.watchTimeFactor,
    required this.scrollSpeedFactor,
    required this.interactionCount,
    this.isSensitive = false,
  });

  List<double> toVector() => [watchTimeFactor, scrollSpeedFactor, interactionCount.toDouble()];
}

@riverpod
class PrivacyRecommendationEngine extends _$PrivacyRecommendationEngine {
  final Random _random = Random.secure();
  final Set<String> _negativePreferences = {};

  @override
  Map<String, UserInterestMetric> build() {
    return {};
  }

  void trackInteraction(String category, {
    required double watchTime,
    required double scrollSpeed,
    bool sensitive = false,
  }) {
    final current = state[category] ?? UserInterestMetric(
      watchTimeFactor: 0,
      scrollSpeedFactor: 0,
      interactionCount: 0,
    );

    state = {
      ...state,
      category: UserInterestMetric(
        watchTimeFactor: (current.watchTimeFactor + watchTime) / 2,
        scrollSpeedFactor: (current.scrollSpeedFactor + scrollSpeed) / 2,
        interactionCount: current.interactionCount + 1,
        isSensitive: current.isSensitive || sensitive,
      ),
    };
  }

  void addNegativePreference(String category) {
    _negativePreferences.add(category);
    ref.invalidateSelf();
  }

  /// Adaptive Epsilon (ε) Mechanism:
  /// Higher privacy (lower epsilon) for sensitive categories.
  List<double> getNoisyProfileVector() {
    final profile = _aggregateProfile();
    final bool hasSensitive = state.values.any((m) => m.isSensitive);

    // Adaptive ε: Base is 1.0, drops to 0.5 if sensitive data is present
    final double epsilon = hasSensitive ? 0.5 : 1.0;
    final double b = 1.0 / epsilon;

    return profile.map((val) {
      // Inject negative preference signal into the vector (Mock logic)
      double baseVal = val;
      if (_negativePreferences.isNotEmpty && val > 0.5) {
         baseVal -= 0.2; // Diminish overall score if negative prefs exist
      }
      return baseVal + _sampleLaplace(b);
    }).toList();
  }

  List<double> _aggregateProfile() {
    if (state.isEmpty) return List.filled(3, 0.0);

    double avgWatch = 0;
    double avgScroll = 0;
    double totalInteractions = 0;

    for (var entry in state.entries) {
      if (_negativePreferences.contains(entry.key)) continue;

      avgWatch += entry.value.watchTimeFactor;
      avgScroll += entry.value.scrollSpeedFactor;
      totalInteractions += entry.value.interactionCount;
    }

    final count = max(1, state.length - _negativePreferences.length);
    return [avgWatch / count, avgScroll / count, totalInteractions / count];
  }

  double _sampleLaplace(double b) {
    final u = _random.nextDouble() - 0.5;
    return -b * (u >= 0 ? 1 : -1) * log(1 - 2 * u.abs());
  }
}
