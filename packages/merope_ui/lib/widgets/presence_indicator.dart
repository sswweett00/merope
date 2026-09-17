import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

enum PresenceStatus { online, idle, dnd, offline }

class PresenceIndicator extends StatelessWidget {
  final PresenceStatus status;
  final double size;
  final MeropeColorTokens tokens;
  final String? activity;

  const PresenceIndicator({
    super.key,
    required this.status,
    required this.tokens,
    this.size = 12.0,
    this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    if (activity != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(color),
          const SizedBox(width: 8),
          Text(
            activity!,
            style: TextStyle(
                color: tokens.textSecondary,
                fontSize: 11,
                fontStyle: FontStyle.italic),
          ),
        ],
      );
    }

    return _buildDot(color);
  }

  Widget _buildDot(Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case PresenceStatus.online:
        return tokens.onlineStatus;
      case PresenceStatus.idle:
        return tokens.idleStatus;
      case PresenceStatus.dnd:
        return tokens.dndStatus;
      case PresenceStatus.offline:
        return tokens.offlineStatus;
    }
  }
}
