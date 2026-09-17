import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import '../logic/catalyst_logic.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class CatalystDashboard extends ConsumerStatefulWidget {
  const CatalystDashboard({super.key});

  @override
  ConsumerState<CatalystDashboard> createState() => _CatalystDashboardState();
}

class _CatalystDashboardState extends ConsumerState<CatalystDashboard>
    with SingleTickerProviderStateMixin {
  ConfettiController _confettiController = ConfettiController();
  bool _hasCelebrated = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalystAsync = ref.watch(catalystControllerProvider);
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    final reqs = catalystAsync.value;
    if (reqs == null) return const Center(child: CircularProgressIndicator());

    if (reqs.isActive && !_hasCelebrated && reqs.earnings >= 1000) {
      _hasCelebrated = true;
      _confettiController.play();
      MeropeHaptics.neuralSyncPulse();
    }

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('MEROPE CATALYST PROGRAM'),
        backgroundColor: tokens.surface,
        foregroundColor: tokens.textPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(catalystControllerProvider.notifier).activateCatalyst(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Monetize Your Influence',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary)),
              const SizedBox(height: 8),
              Text(
                  'Become a Merope Catalyst and earn rewards from your content.',
                  style: TextStyle(color: tokens.textSecondary)),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: MeropeTokens.durationNormal,
                child: reqs.isActive
                    ? _buildActiveStatus(tokens, reqs)
                    : _buildEligibilitySection(reqs, tokens, ref),
              ),
              const SizedBox(height: 32),
              _buildSpendingAnalytics(tokens),
              const SizedBox(height: 32),
              _buildTierProgression(tokens, reqs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveStatus(
      MeropeColorTokens tokens, CatalystRequirements reqs) {
    return RepaintBoundary(
      child: MeropeCard(
        color: tokens.surface,
        child: Column(
          children: [
            Icon(Icons.verified, color: tokens.primary, size: 64),
            const SizedBox(height: 16),
            Text('Catalyst Program Active',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary)),
            const SizedBox(height: 8),
            const Text('You are now earning from your content!'),
            const SizedBox(height: 16),
            _AnimatedEarnings(earnings: reqs.earnings, tokens: tokens),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilitySection(
      CatalystRequirements reqs, MeropeColorTokens tokens, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnimatedProgressCard(
          label: 'Nodes (Followers)',
          current: reqs.currentFollowers,
          req: reqs.requiredFollowers,
          progress: reqs.followerProgress,
          tokens: tokens,
        ),
        const SizedBox(height: 16),
        _AnimatedProgressCard(
          label: 'Pulses (Likes)',
          current: reqs.currentLikes,
          req: reqs.requiredLikes,
          progress: reqs.likesProgress,
          tokens: tokens,
        ),
        const SizedBox(height: 32),
        MeropeButton(
          text: reqs.isEligible ? 'Activate Catalyst' : 'Requirements Not Met',
          onPressed: reqs.isEligible
              ? () => ref
                  .read(catalystControllerProvider.notifier)
                  .activateCatalyst()
              : null,
        ),
        const SizedBox(height: 12),
        if (kDebugMode)
          TextButton(
            onPressed: () =>
                ref.read(catalystControllerProvider.notifier).simulateGrowth(),
            child: const Text('Simulate Growth (Debug)'),
          ),
      ],
    );
  }

  Widget _buildSpendingAnalytics(MeropeColorTokens tokens) {
    return MeropeCard(
      color: tokens.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spending Analytics',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary)),
          const SizedBox(height: 16),
          _SimpleBarChart(tokens: tokens),
        ],
      ),
    );
  }

  Widget _buildTierProgression(
      MeropeColorTokens tokens, CatalystRequirements reqs) {
    final tier = reqs.tier;
    final tierIndex =
        {'None': 0, 'Bronze': 1, 'Silver': 2, 'Gold': 3}[tier] ?? 0;
    return MeropeCard(
      color: tokens.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tier Progression',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: ['Bronze', 'Silver', 'Gold'].map((t) {
              final isActive =
                  ['Bronze', 'Silver', 'Gold'].indexOf(t) < tierIndex;
              final isCurrent = t == tier;
              return Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isActive ? tokens.primary : tokens.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: isCurrent ? tokens.primary : Colors.transparent,
                        width: 2),
                  ),
                  child: Center(
                      child: Text(t,
                          style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : tokens.textSecondary,
                              fontWeight: FontWeight.bold))),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _AnimatedProgressCard extends StatelessWidget {
  final String label;
  final int current;
  final int req;
  final double progress;
  final MeropeColorTokens tokens;

  const _AnimatedProgressCard(
      {required this.label,
      required this.current,
      required this.req,
      required this.progress,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MeropeCard(
        color: tokens.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$current / $req'),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: MeropeTokens.durationSlow,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: tokens.border,
                  color: tokens.primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedEarnings extends StatelessWidget {
  final double earnings;
  final MeropeColorTokens tokens;
  const _AnimatedEarnings({required this.earnings, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: earnings),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text('${value.toStringAsFixed(2)} MRO Earned',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: tokens.onlineStatus));
      },
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _SimpleBarChart({required this.tokens});

  @override
  Widget build(BuildContext context) {
    final data = [320.0, 450.0, 200.0, 580.0, 390.0, 620.0];
    final maxValue = data.reduce(max);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: data.map((v) {
        final height = (v / maxValue) * 120;
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: height),
          duration: MeropeTokens.durationSlow,
          builder: (context, value, child) {
            return Container(
                width: 24,
                height: value,
                decoration: BoxDecoration(
                    color: tokens.primary,
                    borderRadius: BorderRadius.circular(4)));
          },
        );
      }).toList(),
    );
  }
}
