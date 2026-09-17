import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/tokens/merope_tokens.dart';

enum WorkspaceLayer {
  personal,
  work,
  finance;

  String get label {
    switch (this) {
      case WorkspaceLayer.personal:
        return 'Personal';
      case WorkspaceLayer.work:
        return 'Work';
      case WorkspaceLayer.finance:
        return 'Finance';
    }
  }

  IconData get icon {
    switch (this) {
      case WorkspaceLayer.personal:
        return Icons.person_rounded;
      case WorkspaceLayer.work:
        return Icons.work_rounded;
      case WorkspaceLayer.finance:
        return Icons.account_balance_wallet_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case WorkspaceLayer.personal:
        return const Color(0xFF5865F2);
      case WorkspaceLayer.work:
        return const Color(0xFF3BA55D);
      case WorkspaceLayer.finance:
        return const Color(0xFFF0B232);
    }
  }
}

class WorkspaceController extends Notifier<WorkspaceLayer> {
  @override
  WorkspaceLayer build() => WorkspaceLayer.personal;

  void setLayer(WorkspaceLayer layer) => state = layer;
}

final workspaceProvider = NotifierProvider<WorkspaceController, WorkspaceLayer>(
    WorkspaceController.new);

final workspaceThemeProvider = Provider<MeropeColorTokens>((ref) {
  final layer = ref.watch(workspaceProvider);
  final baseTokens = MeropeColorTokens
      .darkDefault(); // Assume dark for now or watch themeProvider

  return MeropeColorTokens(
    background: baseTokens.background,
    surface: baseTokens.surface,
    surfaceVariant: baseTokens.surfaceVariant,
    primary: layer.accentColor,
    primaryVariant: layer.accentColor.withValues(alpha: 0.8),
    onPrimary: baseTokens.onPrimary,
    secondary: baseTokens.secondary,
    onSecondary: baseTokens.onSecondary,
    textPrimary: baseTokens.textPrimary,
    textSecondary: baseTokens.textSecondary,
    border: baseTokens.border,
    onlineStatus: baseTokens.onlineStatus,
    idleStatus: baseTokens.idleStatus,
    dndStatus: baseTokens.dndStatus,
    error: baseTokens.error,
    onError: baseTokens.onError,
    offlineStatus: baseTokens.offlineStatus,
    glassTint: layer.accentColor.withValues(alpha: 0.1),
    auraPrimary: baseTokens.auraPrimary,
    auraSecondary: baseTokens.auraSecondary,
    atmosphereDensity: baseTokens.atmosphereDensity,
  );
});
