import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class MeropeCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final bool hasAtmosphere;
  final double atmosphereIntensity;

  const MeropeCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderRadius,
    this.hasAtmosphere = false,
    this.atmosphereIntensity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    // In a real app, these would come from themeProvider, but keeping it simple for now
    const surfaceColor = Color(0xFF161922);
    const primaryColor = Color(0xFF5865F2);

    return Container(
      decoration: BoxDecoration(
        color: color ?? surfaceColor,
        borderRadius:
            BorderRadius.circular(borderRadius ?? MeropeTokens.radiusMd),
        boxShadow: const [MeropeTokens.shadowSm],
        border: hasAtmosphere
            ? Border.all(
                color:
                    primaryColor.withValues(alpha: atmosphereIntensity * 0.3),
                width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(borderRadius ?? MeropeTokens.radiusMd),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(MeropeTokens.space16),
            child: child,
          ),
        ),
      ),
    );
  }
}
