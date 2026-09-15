import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

/// A production-ready TodoCard implementation.
///
/// Features:
/// - State-driven progress tracking.
/// - Adaptive Material 3 design.
/// - Performance-optimized checkbox handling.
/// - Accessible interactions.
class TodoCard extends StatefulWidget {
  final String title;
  final List<String> tasks;
  final MeropeColorTokens tokens;

  /// Callback triggered when progress changes.
  final ValueChanged<double>? onProgressChanged;

  const TodoCard({
    super.key,
    required this.title,
    required this.tasks,
    required this.tokens,
    this.onProgressChanged,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late final Set<int> _completed;

  @override
  void initState() {
    super.initState();
    _completed = {};
  }

  void _toggleTask(int index, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        _completed.add(index);
      } else {
        _completed.remove(index);
      }

      if (widget.onProgressChanged != null) {
        widget.onProgressChanged!(_calculateProgress());
      }
    });
  }

  double _calculateProgress() {
    return widget.tasks.isEmpty ? 0.0 : _completed.length / widget.tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final progressPercentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      decoration: BoxDecoration(
        color: widget.tokens.background,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        border: Border.all(
          color: widget.tokens.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(progressPercentage),
          const SizedBox(height: MeropeTokens.space8),
          _buildProgressBar(progress),
          const SizedBox(height: MeropeTokens.space16),
          _buildTaskList(),
        ],
      ),
    );
  }

  Widget _buildHeader(int percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: widget.tokens.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            color: widget.tokens.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MeropeTokens.radiusXs),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: widget.tokens.secondary.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation<Color>(widget.tokens.secondary),
        minHeight: 4,
      ),
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: List.generate(widget.tasks.length, (index) {
        final isDone = _completed.contains(index);
        return CheckboxListTile(
          value: isDone,
          onChanged: (val) => _toggleTask(index, val),
          title: Text(
            widget.tasks[index],
            style: TextStyle(
              color: isDone ? widget.tokens.textSecondary : widget.tokens.textPrimary,
              decoration: isDone ? TextDecoration.lineThrough : null,
              fontSize: 14,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: widget.tokens.secondary,
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: VisualDensity.compact,
        );
      }),
    );
  }
}
