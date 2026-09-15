import 'package:flutter/material.dart';

enum EscrowStage { created, funded, shipped, delivered, completed }

class EscrowTimeline extends StatelessWidget {
  final EscrowStage activeStage;

  const EscrowTimeline({super.key, required this.activeStage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: EscrowStage.values.map((stage) {
          final isCompleted = stage.index <= activeStage.index;
          final isLast = stage == EscrowStage.completed;

          return Expanded(
            child: Row(
              children: [
                _buildNode(stage, isCompleted),
                if (!isLast) _buildConnector(isCompleted),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNode(EscrowStage stage, bool isCompleted) {
    final color = isCompleted ? const Color(0xFF5865F2) : Colors.grey.withValues(alpha: 0.3);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
        ),
        const SizedBox(height: 8),
        Text(
          stage.name.toUpperCase(),
          style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildConnector(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: isCompleted ? const Color(0xFF5865F2) : Colors.grey.withValues(alpha: 0.2),
      ),
    );
  }
}
