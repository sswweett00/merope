import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../../data/providers/search_provider.dart';

class NearbyRadar extends ConsumerStatefulWidget {
  const NearbyRadar({super.key});

  @override
  ConsumerState<NearbyRadar> createState() => _NearbyRadarState();
}

class _NearbyRadarState extends ConsumerState<NearbyRadar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final nearbyAsync = ref.watch(nearbyUsersProvider);

    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Radar Rings
            for (var i = 1; i <= 3; i++)
              Container(
                width: 100.0 * i,
                height: 100.0 * i,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tokens.primary.withValues(alpha: 0.2)),
                ),
              ),

            // Rotating Sweep
            RotationTransition(
              turns: _controller,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    center: Alignment.center,
                    colors: [
                      tokens.primary.withValues(alpha: 0.0),
                      tokens.primary.withValues(alpha: 0.2),
                      tokens.primary.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Users
            ...nearbyAsync.when(
              data: (users) => users.asMap().entries.map((entry) {
                final i = entry.key;
                final u = entry.value;
                // Distribute users around the radar
                final angle = (i * 137.5) % 360.0;
                final distance = 40.0 + (i * 20.0) % 100.0;
                final matchesFrequency = u.frequency == 'Distributed Systems'; // Simplified check

                return _RadarUser(
                  angle: angle,
                  distance: distance,
                  name: u.username,
                  tokens: tokens,
                  isMatch: matchesFrequency,
                );
              }).toList(),
              loading: () => [],
              error: (_, __) => [],
            ),

            // Center User
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: tokens.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: tokens.primary.withValues(alpha: 0.5), blurRadius: 10)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarUser extends StatelessWidget {
  final double angle;
  final double distance;
  final String name;
  final MeropeColorTokens tokens;
  final bool isMatch;

  const _RadarUser({
    required this.angle,
    required this.distance,
    required this.name,
    required this.tokens,
    this.isMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    final radian = angle * (pi / 180);
    final x = distance * cos(radian);
    final y = distance * sin(radian);

    return Transform.translate(
      offset: Offset(x, y),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isMatch ? 18 : 12,
            height: isMatch ? 18 : 12,
            decoration: BoxDecoration(
              color: isMatch ? tokens.primary : tokens.secondary,
              shape: BoxShape.circle,
              boxShadow: isMatch ? [BoxShadow(color: tokens.primary.withValues(alpha: 0.5), blurRadius: 10)] : null,
              border: isMatch ? Border.all(color: Colors.white, width: 2) : null,
            ),
            child: isMatch ? const Icon(Icons.flash_on, color: Colors.white, size: 10) : null,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: isMatch ? tokens.textPrimary : tokens.textSecondary,
              fontSize: isMatch ? 11 : 10,
              fontWeight: isMatch ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
