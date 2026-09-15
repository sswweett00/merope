import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class OrbitPlayerModal extends ConsumerStatefulWidget {
  final String title;
  final String category;

  const OrbitPlayerModal({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  ConsumerState<OrbitPlayerModal> createState() => _OrbitPlayerModalState();
}

class _OrbitPlayerModalState extends ConsumerState<OrbitPlayerModal> {
  bool _isActive = true;
  double _streamProgress = 0.35;
  String _fidelityLevel = 'Hyper Fidelity';

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isActive ? Icons.blur_on : Icons.blur_off,
                      size: 80,
                      color: tokens.primary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Resonating: ${widget.title}',
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    dropdownColor: Colors.black87,
                    value: _fidelityLevel,
                    underline: const SizedBox.shrink(),
                    icon: const Icon(Icons.layers, color: Colors.white),
                    items: ['Quantum 8K', 'Hyper Fidelity', 'Standard Node', 'Low Latency']
                        .map((q) => DropdownMenuItem(value: q, child: Text(q, style: const TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _fidelityLevel = val);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                      value: _streamProgress,
                      activeColor: tokens.primary,
                      inactiveColor: Colors.white24,
                      onChanged: (v) => setState(() => _streamProgress = v),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(_isActive ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                              onPressed: () => setState(() => _isActive = !_isActive),
                            ),
                            const SizedBox(width: 8),
                            const Text('Node 42 / Hub 100', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(icon: const Icon(Icons.closed_caption, color: Colors.white), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.graphic_eq, color: Colors.white), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.aspect_ratio, color: Colors.white), onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
