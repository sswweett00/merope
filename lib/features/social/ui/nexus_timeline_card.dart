import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_core/security/biometric_provider.dart';
import 'package:merope_core/utils/merope_acoustics.dart';
import 'package:merope_core/data/services/social_api.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_models/social/post_model.dart';
import '../logic/timeline_provider.dart';
import './widgets/layered_post_widget.dart';
import './widgets/signal_shader_widget.dart';
import 'package:merope_ui/widgets/app_cards/poll_card.dart';
import 'package:merope_ui/widgets/app_cards/todo_card.dart';
import 'package:merope_ui/widgets/app_cards/code_card.dart';
import 'package:merope_ui/widgets/app_cards/countdown_card.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import 'package:confetti/confetti.dart';

class NexusTimelineCard extends ConsumerStatefulWidget {
  final MeropeSignal signal;

  const NexusTimelineCard({
    super.key,
    required this.signal,
  });

  @override
  ConsumerState<NexusTimelineCard> createState() => _NexusTimelineCardState();
}

class _NexusTimelineCardState extends ConsumerState<NexusTimelineCard> {
  final _particleController = StreamController<Offset>.broadcast();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    if (widget.signal.effect == 'confetti') {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _particleController.close();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final timeStr = _formatTimestamp(widget.signal.createdAt);
    final mainResonance =
        widget.signal.resonances.firstWhereOrNull((r) => r.type == '❤️') ??
            (widget.signal.resonances.isNotEmpty
                ? widget.signal.resonances.first
                : const SignalResonance(type: '❤️', amplitude: 0));
    final isViral = mainResonance.amplitude > 50;

    return Dismissible(
      key: Key('dismiss_${widget.signal.id}'),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Quick Echo
          MeropeHaptics.trigger(MeropeTokens.hapticMedium);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Quick Echo!')));
          return false;
        } else {
          // Quick Share
          MeropeHaptics.trigger(MeropeTokens.hapticLight);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preparing to share...')));
          return false;
        }
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 32),
        color: tokens.primary.withValues(alpha: 0.1),
        child: Icon(Icons.repeat, color: tokens.primary),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 32),
        color: tokens.secondary.withValues(alpha: 0.1),
        child: Icon(Icons.share_outlined, color: tokens.secondary),
      ),
      child: Stack(
        children: [
          SignalShaderWidget(
            isViral: isViral,
            auraColor: tokens.primary,
            child: Container(
              margin: const EdgeInsets.only(bottom: MeropeTokens.space16),
              child: widget.signal.layers.isNotEmpty
                  ? LayeredPostWidget(signal: widget.signal, tokens: tokens)
                  : MeropeCard(
                      hasAtmosphere: isViral,
                      atmosphereIntensity:
                          (mainResonance.amplitude / 100).clamp(0.0, 1.0),
                      color: tokens.surface,
                      padding: const EdgeInsets.all(MeropeTokens.space16),
                      onTap: () => context.push('/post/${widget.signal.id}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CardHeader(
                              signal: widget.signal,
                              timeStr: timeStr,
                              tokens: tokens),
                          const SizedBox(height: MeropeTokens.space12),
                          _SignalContent(
                              content: widget.signal.content, tokens: tokens),
                          if (widget.signal.content.length > 200)
                            _NeuralSummaryButton(
                              signalId: widget.signal.id,
                              summary: widget.signal.neuralSummary,
                              tokens: tokens,
                            ),
                          if (widget.signal.repostOf != null) ...[
                            const SizedBox(height: MeropeTokens.space12),
                            _QuotedSignal(
                                signal: widget.signal.repostOf!,
                                tokens: tokens),
                          ],
                          if (widget.signal.media.isNotEmpty) ...[
                            const SizedBox(height: MeropeTokens.space16),
                            RepaintBoundary(
                                child:
                                    _ParallaxMedia(media: widget.signal.media)),
                            if (widget.signal.media
                                .any((m) => m.type == MediaType.audio))
                              RepaintBoundary(
                                  child: _WaveformPlayer(tokens: tokens)),
                          ],
                          if (widget.signal.cards.isNotEmpty) ...[
                            const SizedBox(height: MeropeTokens.space16),
                            ...widget.signal.cards
                                .map((card) => _renderAppCard(card, tokens)),
                          ],
                          const SizedBox(height: MeropeTokens.space16),
                          _CardActions(
                            signal: widget.signal,
                            tokens: tokens,
                            ref: ref,
                            onTriggerParticles: (pos) =>
                                _particleController.add(pos),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          RepaintBoundary(
            child: MeropeParticleEmitter(
              triggerStream: _particleController.stream,
              color: tokens.primary,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderAppCard(MeropeAppCard card, MeropeColorTokens tokens) {
    switch (card.type) {
      case AppCardType.poll:
        return PollCard(
          question: card.data['question'] as String,
          options: List<String>.from(card.data['options'] as List),
          tokens: tokens,
        );
      case AppCardType.todo:
        return TodoCard(
          title: card.data['title'] as String,
          tasks: List<String>.from(card.data['tasks'] as List),
          tokens: tokens,
        );
      case AppCardType.code:
        return CodeCard(
          code: card.data['code'] as String,
          language: card.data['language'] as String,
          tokens: tokens,
        );
      case AppCardType.countdown:
        return CountdownCard(
          title: card.data['title'] as String,
          target: DateTime.parse(card.data['target'] as String),
          tokens: tokens,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return DateFormat('MMM d').format(date);
  }
}

class _SignalContent extends StatelessWidget {
  final String content;
  final MeropeColorTokens tokens;

  const _SignalContent({required this.content, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: tokens.textPrimary,
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.1,
        ),
        children: _parseContent(content),
      ),
    );
  }

  List<TextSpan> _parseContent(String text) {
    final List<TextSpan> spans = [];
    final regExp = RegExp(r'(\*\*.*?\*\*|`.*?`|#\w+)');
    int lastIndex = 0;

    for (final match in regExp.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      final matched = match.group(0)!;
      if (matched.startsWith('**')) {
        spans.add(TextSpan(
          text: matched.replaceAll('**', ''),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (matched.startsWith('`')) {
        spans.add(TextSpan(
          text: matched.replaceAll('`', ''),
          style: TextStyle(
            fontFamily: 'monospace',
            backgroundColor: tokens.primary.withValues(alpha: 0.1),
            color: tokens.primary,
          ),
        ));
      } else if (matched.startsWith('#')) {
        spans.add(TextSpan(
          text: matched,
          style: TextStyle(color: tokens.primary, fontWeight: FontWeight.bold),
        ));
      }
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }
}

class _ParallaxMedia extends StatefulWidget {
  final List<SignalMedia> media;

  const _ParallaxMedia({required this.media});

  @override
  State<_ParallaxMedia> createState() => _ParallaxMediaState();
}

class _ParallaxMediaState extends State<_ParallaxMedia> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return const SizedBox.shrink();

    final first = widget.media.first;
    if (first.type == MediaType.sticker) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
          child: MeropeImage(
            imageUrl: first.url,
            fit: BoxFit.contain,
            enableViewer: true,
          ),
        ),
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.media.length,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemBuilder: (context, index) {
                    final item = widget.media[index];
                    return GestureDetector(
                      onTap: () => _showSmartViewer(context, item.url),
                      child: Flow(
                        delegate: _ParallaxFlowDelegate(
                          scrollable: Scrollable.of(context),
                          listItemContext: context,
                        ),
                        children: [
                          MeropeImage(
                            imageUrl: item.url,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (widget.media.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          widget.media.length,
                          (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                width: _currentPage == i ? 12 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentPage == i
                                      ? Colors.white
                                      : Colors.white54,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              )),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSmartViewer(BuildContext context, String url) {
    MeropeImageViewerModal.show(
      context,
      imageUrl: url,
      title: 'Post Media',
      subtitle: 'Neural Integrity: VERIFIED ✅',
    );
  }
}

class _ParallaxFlowDelegate extends FlowDelegate {
  _ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox?;
    if (scrollableBox == null) return;

    final listItemBox = listItemContext.findRenderObject() as RenderBox?;
    if (listItemBox == null) return;

    final listItemOffset =
        listItemBox.localToGlobal(Offset.zero, ancestor: scrollableBox);

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    final backgroundSize = context.getChildSize(0)!;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(_ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext;
  }
}

class _CardHeader extends StatelessWidget {
  final MeropeSignal signal;
  final String timeStr;
  final MeropeColorTokens tokens;

  const _CardHeader(
      {required this.signal, required this.timeStr, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AuthorAvatar(signal: signal, tokens: tokens),
        const SizedBox(width: MeropeTokens.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    signal.author.displayName ?? signal.author.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  if (signal.author.isVerified) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.verified, color: tokens.primary, size: 14),
                  ],
                ],
              ),
              Text(
                '@${signal.author.username} • $timeStr',
                style: TextStyle(
                  color: tokens.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_horiz, color: tokens.textSecondary, size: 20),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  final MeropeSignal signal;
  final MeropeColorTokens tokens;

  const _AuthorAvatar({required this.signal, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile/${signal.author.id}'),
      child: Hero(
        tag: 'avatar_${signal.author.id}',
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                tokens.primary.withValues(alpha: 0.7),
                tokens.secondary.withValues(alpha: 0.7)
              ],
            ),
          ),
          child: MeropeImage.avatar(
            imageUrl: signal.author.avatarUrl,
            radius: 21,
            initials: signal.author.username,
          ),
        ),
      ),
    );
  }
}

class _WaveformPlayer extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _WaveformPlayer({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: tokens.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.play_arrow_rounded, color: tokens.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  20,
                  (i) => Container(
                        width: 2,
                        height: 10.0 + (i % 5) * 5,
                        color: tokens.primary.withValues(alpha: 0.5),
                      )),
            ),
          ),
          const SizedBox(width: 12),
          Text('0:12',
              style: TextStyle(color: tokens.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  final MeropeSignal signal;
  final MeropeColorTokens tokens;
  final WidgetRef ref;
  final Function(Offset position) onTriggerParticles;

  const _CardActions({
    required this.signal,
    required this.tokens,
    required this.ref,
    required this.onTriggerParticles,
  });

  @override
  Widget build(BuildContext context) {
    final mainResonance =
        signal.resonances.firstWhereOrNull((r) => r.type == '❤️') ??
            (signal.resonances.isNotEmpty
                ? signal.resonances.first
                : const SignalResonance(type: '❤️', amplitude: 0));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ResonanceMeter(
          initialAmplitude: mainResonance.amplitude,
          isResonated: mainResonance.isResonated,
          icon: '❤️',
          activeColor: tokens.primary,
          onTriggerParticles: onTriggerParticles,
          onResonanceComplete: (added) {
            MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
            MeropeAcoustics.trigger(AcousticEffect.resonance);
            ref
                .read(nexusTimelineProvider.notifier)
                .resonateSignal(signal.id, '❤️', added);
          },
        ),
        _ActionButton(
          icon: Icons.bubble_chart_outlined,
          label: '${signal.nodeCount}',
          onTap: () {
            MeropeHaptics.trigger(MeropeTokens.hapticLight);
            context.push('/post/${signal.id}');
          },
          tokens: tokens,
        ),
        _ActionButton(
          icon: Icons.repeat,
          label: '${signal.amplificationCount}',
          isActive:
              signal.resonances.any((r) => r.type == '🔄' && r.isResonated),
          activeColor: tokens.secondary,
          onTap: () {
            MeropeHaptics.trigger(MeropeTokens.hapticMedium);
            MeropeAcoustics.trigger(AcousticEffect.transmission);
            ref
                .read(nexusTimelineProvider.notifier)
                .resonateSignal(signal.id, '🔄', 1);
          },
          tokens: tokens,
        ),
        _ActionButton(
          icon: Icons.electric_bolt_outlined,
          label: 'Wave',
          activeColor: Colors.amber,
          onTap: () async {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final position = box.localToGlobal(Offset.zero);

            // Zenith: Large tipping requires biometric handshake
            final success =
                await ref.read(biometricAuthProvider.notifier).authenticate(
                      reason: 'Authorize 100 MRO Energy Wave Transmission',
                    );

            if (!success) {
              MeropeAcoustics.trigger(AcousticEffect.error);
              return;
            }

            MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
            MeropeAcoustics.trigger(AcousticEffect.resonance);
            onTriggerParticles(position);

            final api = ref.read(socialApiServiceProvider);
            final result = await api.tipSignal(signal.id, 100);
            if (result.isSuccess && context.mounted) {
              MeropeAcoustics.trigger(AcousticEffect.syncSuccess);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Energy wave authorized! +50 XP'),
                    duration: Duration(seconds: 1)),
              );
            }
          },
          tokens: tokens,
        ),
        IconButton(
          icon:
              Icon(Icons.share_outlined, size: 20, color: tokens.textSecondary),
          onPressed: () {
            MeropeHaptics.trigger(MeropeTokens.hapticSoft);
          },
        ),
        _ActionButton(
          icon: Icons.rocket_launch_outlined,
          label: signal.isBoosted ? 'Boosted' : 'Boost',
          isActive: signal.isBoosted,
          activeColor: tokens.primary,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Signal Boost: 50 MRO spent to reach +5000 explorers')),
            );
          },
          tokens: tokens,
        ),
      ],
    );
  }
}

class _NeuralSummaryButton extends StatefulWidget {
  final String signalId;
  final String? summary;
  final MeropeColorTokens tokens;

  const _NeuralSummaryButton(
      {required this.signalId, this.summary, required this.tokens});

  @override
  State<_NeuralSummaryButton> createState() => _NeuralSummaryButtonState();
}

class _NeuralSummaryButtonState extends State<_NeuralSummaryButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
          icon:
              Icon(Icons.auto_awesome, size: 14, color: widget.tokens.primary),
          label: Text(_isExpanded ? 'Hide Summary' : 'Summarize with AI',
              style: TextStyle(
                  color: widget.tokens.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, minimumSize: Size.zero),
        ),
        if (_isExpanded)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.tokens.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: widget.tokens.primary.withValues(alpha: 0.1)),
            ),
            child: Text(
              widget.summary ??
                  'AI is analyzing this signal... Neural core synced.',
              style: TextStyle(
                  color: widget.tokens.textPrimary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}

class _QuotedSignal extends StatelessWidget {
  final MeropeSignal signal;
  final MeropeColorTokens tokens;

  const _QuotedSignal({required this.signal, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        border: Border.all(color: tokens.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MeropeImage.avatar(
                imageUrl: signal.author.avatarUrl,
                radius: 10,
                initials: signal.author.username,
              ),
              const SizedBox(width: 8),
              Text(
                signal.author.displayName ?? signal.author.username,
                style: TextStyle(
                    color: tokens.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            signal.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: tokens.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onTap;
  final MeropeColorTokens tokens;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.activeColor,
    required this.onTap,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? (activeColor ?? tokens.primary)
                  : tokens.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isActive
                    ? (activeColor ?? tokens.primary)
                    : tokens.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
