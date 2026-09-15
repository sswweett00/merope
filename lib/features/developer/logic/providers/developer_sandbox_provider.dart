import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

enum SandboxEnvironment { sandbox, staging, production }

enum ErrorInjectionMode { none, timeout, http500, http503, random }

enum NetworkCondition { g2, g3, g4, wifi, offline }

enum LogLevel { verbose, debug, info, warn, error }

class SandboxState {
  final SandboxEnvironment environment;
  final bool isMockServerEnabled;
  final double latencyJitterMs;
  final ErrorInjectionMode errorInjection;
  final double errorProbability;
  final NetworkCondition networkCondition;
  final LogLevel logLevel;
  final bool featureFlagPlayground;
  final Map<String, bool> featureFlags;

  const SandboxState({
    this.environment = SandboxEnvironment.sandbox,
    this.isMockServerEnabled = false,
    this.latencyJitterMs = 0,
    this.errorInjection = ErrorInjectionMode.none,
    this.errorProbability = 0.0,
    this.networkCondition = NetworkCondition.wifi,
    this.logLevel = LogLevel.info,
    this.featureFlagPlayground = false,
    this.featureFlags = const {},
  });

  SandboxState copyWith({
    SandboxEnvironment? environment,
    bool? isMockServerEnabled,
    double? latencyJitterMs,
    ErrorInjectionMode? errorInjection,
    double? errorProbability,
    NetworkCondition? networkCondition,
    LogLevel? logLevel,
    bool? featureFlagPlayground,
    Map<String, bool>? featureFlags,
  }) {
    return SandboxState(
      environment: environment ?? this.environment,
      isMockServerEnabled: isMockServerEnabled ?? this.isMockServerEnabled,
      latencyJitterMs: latencyJitterMs ?? this.latencyJitterMs,
      errorInjection: errorInjection ?? this.errorInjection,
      errorProbability: errorProbability ?? this.errorProbability,
      networkCondition: networkCondition ?? this.networkCondition,
      logLevel: logLevel ?? this.logLevel,
      featureFlagPlayground: featureFlagPlayground ?? this.featureFlagPlayground,
      featureFlags: featureFlags ?? this.featureFlags,
    );
  }
}

class DeveloperSandboxNotifier extends StateNotifier<SandboxState> {
  DeveloperSandboxNotifier() : super(const SandboxState());

  void setEnvironment(SandboxEnvironment env) {
    state = state.copyWith(environment: env);
    MeropeHaptics.selectionClick();
  }

  void toggleMockServer() {
    state = state.copyWith(isMockServerEnabled: !state.isMockServerEnabled);
    MeropeHaptics.lightImpact();
  }

  void setLatencyJitter(double ms) {
    state = state.copyWith(latencyJitterMs: ms);
  }

  void setErrorInjection(ErrorInjectionMode mode) {
    state = state.copyWith(errorInjection: mode);
  }

  void setErrorProbability(double prob) {
    state = state.copyWith(errorProbability: prob);
  }

  void setNetworkCondition(NetworkCondition condition) {
    state = state.copyWith(networkCondition: condition);
    MeropeHaptics.selectionClick();
  }

  void setLogLevel(LogLevel level) {
    state = state.copyWith(logLevel: level);
  }

  void toggleFeatureFlagPlayground() {
    state = state.copyWith(featureFlagPlayground: !state.featureFlagPlayground);
  }

  void setFeatureFlag(String flag, bool value) {
    state = state.copyWith(featureFlags: {...state.featureFlags, flag: value});
  }

  void clearAllLocalData() {
    state = const SandboxState();
  }
}

final developerSandboxProvider = StateNotifierProvider<DeveloperSandboxNotifier, SandboxState>((ref) {
  return DeveloperSandboxNotifier();
});
