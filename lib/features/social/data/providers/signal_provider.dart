import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_models/social/post_model.dart';
import '../../logic/timeline_provider.dart';

final signalProvider =
    FutureProvider.family<MeropeSignal, String>((ref, signalId) async {
  final timeline = await ref.watch(nexusTimelineProvider.future);

  try {
    return timeline.items.firstWhere((element) => element.id == signalId);
  } catch (e) {
    // If not found in timeline, we'd normally fetch from API
    // For now, return a placeholder or throw
    throw Exception('Signal not found');
  }
});
