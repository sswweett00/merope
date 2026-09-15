import 'package:flutter/services.dart';
import '../theme/tokens/merope_tokens.dart';

/// Centralized Haptics Engine for Merope.
/// Provides synchronized haptic feedback for different "Resonance" intensities.
class MeropeHaptics {
  MeropeHaptics._();

  static Future<void> trigger(int intensity) async {
    switch (intensity) {
      case MeropeTokens.hapticSoft:
        await HapticFeedback.selectionClick();
        break;
      case MeropeTokens.hapticLight:
        await HapticFeedback.lightImpact();
        break;
      case MeropeTokens.hapticMedium:
        await HapticFeedback.mediumImpact();
        break;
      case MeropeTokens.hapticHeavy:
        await HapticFeedback.heavyImpact();
        break;
      case MeropeTokens.hapticSelection:
        await HapticFeedback.selectionClick();
        break;
      default:
        await HapticFeedback.lightImpact();
    }
  }

  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Specialized haptic for continuous actions (like Resonance Meter)
  static Future<void> vibrateBurst() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Specialized haptic for critical errors
  static Future<void> vibrateError() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Zenith: High-Frequency Neural Pulse Sequence
  static Future<void> neuralSyncPulse() async {
    await HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.mediumImpact();
  }
}
