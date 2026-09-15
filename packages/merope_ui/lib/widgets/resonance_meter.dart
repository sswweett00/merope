import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResonanceMeter extends StatefulWidget {
  final int initialAmplitude;
  final bool isResonated;
  final String icon;
  final Color activeColor;
  final Function(int addedAmplitude) onResonanceComplete;
  final Function(Offset position)? onTriggerParticles;

  const ResonanceMeter({
    super.key,
    required this.initialAmplitude,
    required this.isResonated,
    required this.icon,
    required this.activeColor,
    required this.onResonanceComplete,
    this.onTriggerParticles,
  });

  @override
  State<ResonanceMeter> createState() => _ResonanceMeterState();
}

class _ResonanceMeterState extends State<ResonanceMeter> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _resonanceTimer;
  int _currentAddedAmplitude = 0;
  bool _isPressing = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _resonanceTimer?.cancel();
    super.dispose();
  }

  void _startResonating(Offset position) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPressing = true;
      _currentAddedAmplitude = 0;
    });
    _pulseController.repeat(reverse: true);

    _resonanceTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentAddedAmplitude++;
      });
      if (_currentAddedAmplitude % 5 == 0) {
        HapticFeedback.lightImpact();
        widget.onTriggerParticles?.call(position);
      }
      if (_currentAddedAmplitude >= 100) {
        _stopResonating();
      }
    });
  }

  void _stopResonating() {
    if (!_isPressing) return;

    _resonanceTimer?.cancel();
    _pulseController.stop();
    _pulseController.reset();

    widget.onResonanceComplete(_currentAddedAmplitude);

    setState(() {
      _isPressing = false;
    });
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) => _startResonating(details.globalPosition),
      onLongPressEnd: (_) => _stopResonating(),
      onTapDown: (details) {
        widget.onTriggerParticles?.call(details.globalPosition);
        widget.onResonanceComplete(1);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (_isPressing)
                ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.5).animate(_pulseController),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.activeColor.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              Text(
                widget.icon == '⚡' ? '❤️' : widget.icon,
                style: TextStyle(
                  fontSize: _isPressing ? 24 : 18,
                  shadows: widget.isResonated ? [
                    Shadow(color: widget.activeColor, blurRadius: 10),
                  ] : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.initialAmplitude + _currentAddedAmplitude}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.isResonated || _isPressing
                  ? widget.activeColor
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
