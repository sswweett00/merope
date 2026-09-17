import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class PollCard extends StatefulWidget {
  final String question;
  final List<String> options;
  final MeropeColorTokens tokens;

  const PollCard({
    super.key,
    required this.question,
    required this.options,
    required this.tokens,
  });

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.tokens.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.tokens.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: TextStyle(
                color: widget.tokens.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...List.generate(widget.options.length, (index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.tokens.primary.withValues(alpha: 0.1)
                      : widget.tokens.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? widget.tokens.primary
                        : widget.tokens.border,
                    width: isSelected ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.options[index],
                        style: TextStyle(
                          color: isSelected
                              ? widget.tokens.primary
                              : widget.tokens.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle,
                          color: widget.tokens.primary, size: 18),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
