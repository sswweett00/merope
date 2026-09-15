import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/connectivity_service.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';

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
              Positioned.fill(child: _AtmosphereLayer(tokens: tokens, overrideColor: auraOverride)),
              Row(
                children: [
                  if (isDesktop && universalRail != null) universalRail!,
                  if (isDesktop && sidebar != null) sidebar!,
                  Expanded(child: body),
                ],
              ),
              const Positioned(top: 48, right: 24, child: _ServerConnectionIndicator()),
            ],
          ),
        );
      },
    );
  }
}

class _ServerConnectionIndicator extends ConsumerWidget {
  const _ServerConnectionIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityProvider);
    if (status == ConnectivityStatus.online) return const SizedBox.shrink();
    final tokens = ref.watch(themeProvider).currentTokens;
    final color = tokens.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        'SERVER CONNECTION LOST',
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
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
          colors: [primary.withValues(alpha: 0.15), tokens.auraSecondary.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}
