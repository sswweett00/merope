import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class SynergyThreadView extends ConsumerWidget {
  final String collectiveName;
  const SynergyThreadView({super.key, required this.collectiveName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(collectiveName, style: TextStyle(color: tokens.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Synergy collective node', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          // Reusing NexusTimelineCard for threads, simulating Reddit posts
          return const Padding(
             padding: EdgeInsets.only(bottom: 12),
             child: Text('Thread content placeholder - Reusing design language.'),
          );
        },
      ),
    );
  }
}
