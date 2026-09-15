import 'dart:convert';
import 'package:flutter/material.dart';
import 'tokens/merope_tokens.dart';

/// Full Configurable Theme Model (JSON Exportable/Importable)
class MeropeTheme {
  final String id;
  final String name;
  final MeropeColorTokens colors;
  final double borderRadius;
  final double blurAmount;
  final String fontFamily;

  const MeropeTheme({
    required this.id,
    required this.name,
    required this.colors,
    this.borderRadius = MeropeTokens.radiusMd,
    this.blurAmount = MeropeTokens.blurMedium,
    this.fontFamily = 'Inter',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'borderRadius': borderRadius,
      'blurAmount': blurAmount,
      'fontFamily': fontFamily,
      'colors': {
        'background': colors.background.toARGB32(),
        'surface': colors.surface.toARGB32(),
        'primary': colors.primary.toARGB32(),
        'textPrimary': colors.textPrimary.toARGB32(),
        'textSecondary': colors.textSecondary.toARGB32(),
        'border': colors.border.toARGB32(),
      },
    };
  }

  factory MeropeTheme.fromJson(Map<String, dynamic> json) {
    final colorsMap = json['colors'] as Map<String, dynamic>? ?? {};
    return MeropeTheme(
      id: json['id'] as String? ?? 'custom',
      name: json['name'] as String? ?? 'Custom Theme',
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? MeropeTokens.radiusMd,
      blurAmount: (json['blurAmount'] as num?)?.toDouble() ?? MeropeTokens.blurMedium,
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      colors: MeropeColorTokens(
        background: Color(colorsMap['background'] as int? ?? 0xFF0F1117),
        surface: Color(colorsMap['surface'] as int? ?? 0xFF161922),
        surfaceVariant: const Color(0xFF1E2230),
        primary: Color(colorsMap['primary'] as int? ?? 0xFF5865F2),
        primaryVariant: const Color(0xFF4752C4),
        onPrimary: const Color(0xFFFFFFFF),
        secondary: const Color(0xFF3BA55D),
        onSecondary: const Color(0xFFFFFFFF),
        textPrimary: Color(colorsMap['textPrimary'] as int? ?? 0xFFF2F3F5),
        textSecondary: Color(colorsMap['textSecondary'] as int? ?? 0xFF949BA4),
        border: Color(colorsMap['border'] as int? ?? 0xFF2B2D31),
        onlineStatus: const Color(0xFF23A55A),
        idleStatus: const Color(0xFFF0B232),
        dndStatus: const Color(0xFFF23F43),
        error: const Color(0xFFF23F43),
        onError: const Color(0xFFFFFFFF),
        offlineStatus: const Color(0xFF80848E),
        glassTint: const Color(0x330F1117),
        auraPrimary: const Color(0x1A5865F2),
        auraSecondary: const Color(0x1A3BA55D),
        atmosphereDensity: 0.15,
      ),
    );
  }

  String exportToJson() => jsonEncode(toJson());
}
