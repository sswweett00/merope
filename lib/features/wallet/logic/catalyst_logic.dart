import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalystRequirements {
  final int currentFollowers;
  final int currentLikes;
  final int requiredFollowers = 999;
  final int requiredLikes = 3333;
  final bool isEligible;
  final bool isActive;
  final double earnings;

  CatalystRequirements({
    required this.currentFollowers,
    required this.currentLikes,
    required this.isActive,
    this.earnings = 0.0,
  }) : isEligible = currentFollowers >= 999 && currentLikes >= 3333;

  double get followerProgress =>
      (currentFollowers / requiredFollowers).clamp(0.0, 1.0);
  double get likesProgress => (currentLikes / requiredLikes).clamp(0.0, 1.0);
  String get tier {
    if (!isActive) return 'None';
    if (earnings >= 5000) return 'Gold';
    if (earnings >= 1000) return 'Silver';
    return 'Bronze';
  }
}

class CatalystController extends AsyncNotifier<CatalystRequirements?> {
  @override
  FutureOr<CatalystRequirements?> build() async {
    return CatalystRequirements(
      currentFollowers: 500,
      currentLikes: 1200,
      isActive: false,
      earnings: 0.0,
    );
  }

  Future<void> activateCatalyst() async {
    final current = state.value;
    if (current == null || !current.isEligible || current.isActive) return;
    state = AsyncValue.data(
      CatalystRequirements(
        currentFollowers: current.currentFollowers,
        currentLikes: current.currentLikes,
        isActive: true,
        earnings: current.earnings,
      ),
    );
  }

  Future<void> simulateGrowth() async {
    if (!kDebugMode) return;
    state = AsyncValue.data(
      CatalystRequirements(
        currentFollowers: 1200,
        currentLikes: 4500,
        isActive: state.value?.isActive ?? false,
        earnings: state.value?.earnings ?? 0.0,
      ),
    );
  }
}

final catalystControllerProvider =
    AsyncNotifierProvider<CatalystController, CatalystRequirements?>(
  CatalystController.new,
);
