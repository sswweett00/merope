import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class MeropeGlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const MeropeGlassContainer({
    super.key,
    required this.child,
    this.blur = MeropeTokens.blurLow,
    this.opacity = 0.1,
    this.borderRadius = MeropeTokens.radiusMd,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = MeropeColorTokens.darkDefault();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: tokens.glassTint.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: tokens.border.withValues(alpha: 0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
