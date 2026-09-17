import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class LumiaBroadcastControls extends ConsumerWidget {
  const LumiaBroadcastControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TelemetryRow(tokens: tokens),
          const SizedBox(height: 16),
          _EnergyGoalProgress(tokens: tokens),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ControlIcon(
                  icon: Icons.face_retouching_natural,
                  label: 'LENS',
                  tokens: tokens),
              _ControlIcon(
                  icon: Icons.multiline_chart, label: 'STATS', tokens: tokens),
              _ControlIcon(icon: Icons.settings, label: 'OPS', tokens: tokens),
              _ControlIcon(
                  icon: Icons.stop_circle,
                  label: 'END',
                  color: Colors.red,
                  tokens: tokens),
            ],
          ),
        ],
      ),
    );
  }
}

class _TelemetryRow extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _TelemetryRow({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Metric(label: 'BITRATE', value: '4.2 Mbps', color: Colors.green),
        _Metric(label: 'FPS', value: '60', color: Colors.blue),
        _Metric(label: 'VIEWERS', value: '1.2k', color: tokens.primary),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Metric(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 8,
                fontWeight: FontWeight.bold)),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _EnergyGoalProgress extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _EnergyGoalProgress({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('ENERGY WAVE GOAL',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold)),
            Text('450 / 1000 MRO',
                style: TextStyle(
                    color: tokens.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.45,
            minHeight: 4,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(tokens.primary),
          ),
        ),
      ],
    );
  }
}

class _ControlIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final MeropeColorTokens tokens;
  const _ControlIcon(
      {required this.icon,
      required this.label,
      this.color,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: (color ?? tokens.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle),
          child: Icon(icon, color: color ?? tokens.primary, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
