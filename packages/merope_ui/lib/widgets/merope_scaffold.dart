import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_core/sync/sync_provider.dart';
import 'package:merope_core/sync/sync_engine.dart';

class MeropeScaffold extends ConsumerWidget {
  final Widget body;
  final Widget? sidebar;
  final Widget? universalRail;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Color? auraOverride;

  const MeropeScaffold({
    super.key,
    required this.body,
    this.sidebar,
    this.universalRail,
    this.bottomNavigationBar,
    this.appBar,
    this.auraOverride,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: tokens.background,
          appBar: !isDesktop ? appBar : null,
          bottomNavigationBar: bottomNavigationBar,
          body: Stack(
            children: [
              // Atmosphere Aura
              Positioned.fill(
                child: _AtmosphereLayer(tokens: tokens, overrideColor: auraOverride),
              ),
              Row(
                children: [
                  if (isDesktop && universalRail != null) universalRail!,
                  if (isDesktop && sidebar != null) sidebar!,
                  Expanded(
                    child: body,
                  ),
                ],
              ),
              Positioned(
                top: 48,
                right: 24,
                child: _NeuralSyncIndicator(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NeuralSyncIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(syncStatusProvider);
    final telemetryAsync = ref.watch(syncTelemetryControllerProvider);
    final tokens = ref.watch(themeProvider).currentTokens;

    return statusAsync.when(
      data: (status) {
        if (status == SyncStatus.idle) return const SizedBox.shrink();

        final color = status == SyncStatus.syncing ? tokens.primary : tokens.error;
        final pendingCount = telemetryAsync.value?.pendingOperations ?? 0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == SyncStatus.syncing)
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2, color: color),
                )
              else
                Icon(Icons.sync_problem, size: 14, color: color),
              const SizedBox(width: 8),
              Text(
                status == SyncStatus.syncing ? 'NEURAL SYNC' : 'SYNC ERROR',
                style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              if (pendingCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                  child: Text('$pendingCount', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _AtmosphereLayer extends StatelessWidget {
  final MeropeColorTokens tokens;
  final Color? overrideColor;
  const _AtmosphereLayer({required this.tokens, this.overrideColor});

  @override
  Widget build(BuildContext context) {
    final primary = overrideColor ?? tokens.auraPrimary;

    return AnimatedContainer(
      duration: MeropeTokens.durationSlow,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [
            primary.withValues(alpha: 0.15),
            tokens.auraSecondary.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
