import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'energy_drop_overlay.dart';

class LumiaBroadcastView extends ConsumerStatefulWidget {
  final String broadcastId;
  const LumiaBroadcastView({super.key, required this.broadcastId});

  @override
  ConsumerState<LumiaBroadcastView> createState() => _LumiaBroadcastViewState();
}

class _LumiaBroadcastViewState extends ConsumerState<LumiaBroadcastView> {
  bool _isOverlayActive = false;

  void _triggerEnergyDrop() {
    setState(() => _isOverlayActive = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isOverlayActive = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Video Feed
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(Icons.live_tv, color: Colors.white24, size: 80),
              ),
            ),
          ),

          // Header
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: tokens.primary,
                  child: const Text('HB',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Live Stream',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    const Text('2.4k Viewers',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('LIVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Energy Drop Overlay
          if (_isOverlayActive)
            const Positioned.fill(child: EnergyDropOverlay()),

          // Footer Controls
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Say something...',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.flash_on,
                  color: Colors.amber,
                  onTap: _triggerEnergyDrop,
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  icon: Icons.share,
                  color: Colors.white,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
