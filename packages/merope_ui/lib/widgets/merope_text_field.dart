import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class MeropeTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextAlign? textAlign;

  const MeropeTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = MeropeColorTokens.darkDefault();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: MeropeTokens.fontSizeXs,
            fontWeight: FontWeight.w800,
            color: tokens.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: MeropeTokens.space8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          textAlign: textAlign ?? TextAlign.start,
          style: TextStyle(color: tokens.textPrimary, fontSize: MeropeTokens.fontSizeMd),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: tokens.textSecondary.withValues(alpha: 0.5)),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: tokens.textSecondary, size: 20) : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: MeropeTokens.space12,
              vertical: MeropeTokens.space12,
            ),
            filled: true,
            fillColor: tokens.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
              borderSide: BorderSide(color: tokens.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
              borderSide: BorderSide(color: tokens.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
              borderSide: BorderSide(color: tokens.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
