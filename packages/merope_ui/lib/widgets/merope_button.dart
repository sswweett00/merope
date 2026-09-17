import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

enum MeropeButtonStyle { primary, secondary, ghost, danger }

class MeropeButton extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final MeropeButtonStyle style;
  final IconData? icon;
  final bool isLoading;

  const MeropeButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = MeropeButtonStyle.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  ConsumerState<MeropeButton> createState() => _MeropeButtonState();
}

class _MeropeButtonState extends ConsumerState<MeropeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MeropeTokens.durationFast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
          parent: _controller, curve: MeropeTokens.curveMeropeStandard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) => _controller.forward();
  void _handleTapUp(TapUpDetails details) => _controller.reverse();
  void _handleTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;

    Color bgColor;
    Color textColor;

    switch (widget.style) {
      case MeropeButtonStyle.primary:
        bgColor = tokens.primary;
        textColor = tokens.onPrimary;
        break;
      case MeropeButtonStyle.secondary:
        bgColor = tokens.surfaceVariant;
        textColor = tokens.textPrimary;
        break;
      case MeropeButtonStyle.danger:
        bgColor = tokens.dndStatus;
        textColor = tokens.onPrimary;
        break;
      case MeropeButtonStyle.ghost:
        bgColor = Colors.transparent;
        textColor = tokens.textSecondary;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: widget.onPressed != null ? _handleTapDown : null,
        onTapUp: widget.onPressed != null ? _handleTapUp : null,
        onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: 48,
            padding:
                const EdgeInsets.symmetric(horizontal: MeropeTokens.space24),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
              boxShadow: widget.style == MeropeButtonStyle.primary
                  ? [MeropeTokens.shadowSm]
                  : null,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: textColor),
                          const SizedBox(width: MeropeTokens.space8),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: MeropeTokens.fontSizeSm,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
