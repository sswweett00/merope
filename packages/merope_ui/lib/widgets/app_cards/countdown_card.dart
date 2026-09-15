import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class CountdownCard extends StatefulWidget {
  final String title;
  final DateTime target;
  final MeropeColorTokens tokens;

  const CountdownCard({
    super.key,
    required this.title,
    required this.target,
    required this.tokens,
  });

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.target.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft = widget.target.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft.isNegative) {
      return _buildFinishedState();
    }

    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.tokens.primary.withValues(alpha: 0.1), widget.tokens.secondary.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.tokens.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(color: widget.tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TimeUnit(value: days, label: 'Days', tokens: widget.tokens),
              _TimeUnit(value: hours, label: 'Hrs', tokens: widget.tokens),
              _TimeUnit(value: minutes, label: 'Min', tokens: widget.tokens),
              _TimeUnit(value: seconds, label: 'Sec', tokens: widget.tokens),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, color: Colors.green),
          const SizedBox(width: 12),
          Text(
            '${widget.title} is LIVE!',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;
  final MeropeColorTokens tokens;

  const _TimeUnit({required this.value, required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: TextStyle(
            color: tokens.primary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
          ),
        ),
        Text(
          label,
          style: TextStyle(color: tokens.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}
