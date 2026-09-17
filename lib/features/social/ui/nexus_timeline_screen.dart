import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../logic/timeline_provider.dart';
import '../logic/post_filter_provider.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'package:merope_ui/widgets/universal_view_controls.dart';
import 'package:merope_ui/layouts/dynamic_layout_engine.dart';
import 'package:merope_models/social/post_model.dart';
import 'widgets/resonance_streak_widget.dart';
import 'widgets/feed_skeleton.dart';
import 'nexus_timeline_card.dart';
import 'create_post_overlay.dart';

class NexusTimelineScreen extends ConsumerWidget {
  const NexusTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final prefs = ref.watch(viewPreferencesProvider)['feed'] ??
        const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');

    final timelineAsync = ref.watch(filteredTimelineProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: prefs.mode == ViewMode.focus
          ? null
          : FloatingActionButton(
              onPressed: () => CreatePostOverlay.show(context),
              backgroundColor: tokens.primary,
              child: const Icon(Icons.flash_on, color: Colors.white),
            ),
      body: Column(
        children: [
          if (prefs.mode != ViewMode.focus) _TimelineHeader(tokens: tokens),
          const UniversalViewControls(
            domain: 'feed',
            filters: ['All', 'Media', 'Interactive', 'Stories'],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(nexusTimelineProvider.notifier).refresh(),
              color: tokens.primary,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.extentAfter < 200) {
                    ref.read(nexusTimelineProvider.notifier).fetchMore();
                  }
                  return false;
                },
                child: timelineAsync.when(
                  data: (filtered) {
                    if (filtered.isEmpty) {
                      return _EmptyFeedState(tokens: tokens);
                    }

                    final timelineState =
                        ref.read(nexusTimelineProvider).value!;

                    return DynamicLayoutEngine<MeropeSignal>(
                      items: filtered,
                      mode: prefs.mode,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      itemBuilder: (context, index, signal) {
                        Widget card = NexusTimelineCard(signal: signal);

                        if (index == 0 && prefs.mode == ViewMode.list) {
                          card = Column(
                            children: [
                              _QuickBroadcastBar(tokens: tokens, ref: ref),
                              card,
                            ],
                          );
                        }

                        if (index == filtered.length - 1 &&
                            timelineState.hasMore) {
                          return Column(
                            children: [
                              card,
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(
                                    color: tokens.primary),
                              ),
                            ],
                          );
                        }

                        return card;
                      },
                    );
                  },
                  loading: () => FeedSkeleton(tokens: tokens),
                  error: (err, stack) =>
                      Center(child: Text('Loading Error: $err')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFeedState extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _EmptyFeedState({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  tokens.primary.withValues(alpha: 0.1),
                  Colors.transparent
                ],
              ),
            ),
            child: Icon(Icons.radar,
                size: 64, color: tokens.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text(
            'Silence in the Nexus',
            style: TextStyle(
              color: tokens.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No signals detected at this frequency.',
            style: TextStyle(color: tokens.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => CreatePostOverlay.show(context),
            icon: const Icon(Icons.flash_on),
            label: const Text('Broadcast First Signal'),
            style: OutlinedButton.styleFrom(
              foregroundColor: tokens.primary,
              side: BorderSide(color: tokens.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _TimelineHeader({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Feed',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              ResonanceStreakWidget(streak: 12, tokens: tokens),
            ],
          ),
          IconButton(
            icon: Icon(Icons.radar, color: tokens.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _QuickBroadcastBar extends StatefulWidget {
  final MeropeColorTokens tokens;
  final WidgetRef ref;
  const _QuickBroadcastBar({required this.tokens, required this.ref});

  @override
  State<_QuickBroadcastBar> createState() => _QuickBroadcastBarState();
}

class _QuickBroadcastBarState extends State<_QuickBroadcastBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isNotEmpty) {
      widget.ref
          .read(nexusTimelineProvider.notifier)
          .broadcastSignal(_controller.text.trim());
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          top: MeropeTokens.space24, bottom: MeropeTokens.space24),
      padding: const EdgeInsets.all(MeropeTokens.space16),
      decoration: BoxDecoration(
        color: widget.tokens.surface,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        border: Border.all(color: widget.tokens.border, width: 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: widget.tokens.primary.withValues(alpha: 0.1),
            child: Icon(Icons.wifi_tethering, color: widget.tokens.primary),
          ),
          const SizedBox(width: MeropeTokens.space12),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(
                    color: widget.tokens.textSecondary.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: widget.tokens.primary),
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
