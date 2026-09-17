import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignalComments
    extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
  @override
  FutureOr<List<Map<String, dynamic>>> build(String arg) async {
    // Simulated API fetch
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      {
        'id': 'c1',
        'author': 'CyberWave',
        'content': 'Great analysis of the neural patterns! 🌊',
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 2))
            .millisecondsSinceEpoch,
      },
      {
        'id': 'c2',
        'author': 'NodeExplorer',
        'content':
            'The synchronization frequency seems slightly off in the third quadrant.',
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch,
      },
    ];
  }

  Future<void> addComment(String content) async {
    final previousState = state.value ?? [];
    final newComment = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'author': 'me',
      'content': content,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
    state = AsyncValue.data([...previousState, newComment]);
  }
}

final signalCommentsProvider = AsyncNotifierProviderFamily<SignalComments,
    List<Map<String, dynamic>>, String>(SignalComments.new);
