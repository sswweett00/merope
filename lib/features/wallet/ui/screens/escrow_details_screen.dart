import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import '../../data/providers/escrow_provider.dart';

class EscrowDetailsScreen extends ConsumerStatefulWidget {
  final String escrowId;
  const EscrowDetailsScreen({super.key, required this.escrowId});

  @override
  ConsumerState<EscrowDetailsScreen> createState() => _EscrowDetailsScreenState();
}

class _EscrowDetailsScreenState extends ConsumerState<EscrowDetailsScreen> with SingleTickerProviderStateMixin {
  Timer? _countdownTimer;
  Duration? _remaining;
  late AnimationController _stageController;
  late Animation<double> _stageAnimation;

  @override
  void initState() {
    super.initState();
    _stageController = AnimationController(vsync: this, duration: MeropeTokens.durationSlow);
    _stageAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _stageController, curve: MeropeTokens.curveMeropeStandard));
    _stageController.forward();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _stageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final escrowAsync = ref.watch(escrowDetailsProvider(widget.escrowId));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text("Secure Payment", style: TextStyle(color: tokens.textPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: tokens.textPrimary),
            onPressed: () {
              MeropeHaptics.lightImpact();
              ref.invalidate(escrowDetailsProvider(widget.escrowId));
            },
          ),
        ],
      ),
      body: escrowAsync.when(
        data: (escrow) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(escrowDetailsProvider(widget.escrowId).notifier).build(widget.escrowId);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusHeader(tokens, escrow),
                  const SizedBox(height: 16),
                  _buildAnimatedTimeline(escrow.stage, tokens),
                  if (escrow.autoReleaseAt != null) ...[
                    const SizedBox(height: 16),
                    _buildCountdownTimer(tokens, escrow.autoReleaseAt!),
                  ],
                  const SizedBox(height: 32),
                  _buildDetailSection("Amount", escrow.amount, tokens),
                  _buildDetailSection("Seller", escrow.seller, tokens),
                  _buildDetailSection("Description", escrow.description, tokens),
                  _buildDetailSection("Currency", escrow.currency, tokens),
                  const SizedBox(height: 48),
                  if (escrow.status == 'Held') ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => ref.read(escrowDetailsProvider(widget.escrowId).notifier).releasePayment(),
                        style: ElevatedButton.styleFrom(backgroundColor: tokens.primary, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
                        child: const Text("Release Payment"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _showDisputeSheet(context, tokens),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text("Open Dispute"),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: tokens.onlineStatus.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
                        ),
                        child: Text(
                          "Payment Released",
                          style: TextStyle(color: tokens.onlineStatus, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (escrow.receiptUrl != null)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            MeropeHaptics.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receipt shared')));
                          },
                          icon: Icon(Icons.share, color: tokens.primary),
                          label: Text('Download Receipt', style: TextStyle(color: tokens.primary)),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            children: [
              Text('Escrow Error: $err', style: TextStyle(color: tokens.dndStatus)),
              const SizedBox(height: 12),
              MeropeButton(text: 'Retry', onPressed: () => ref.invalidate(escrowDetailsProvider(widget.escrowId))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(MeropeColorTokens tokens, MeropeEscrow escrow) {
    final isHeld = escrow.status == 'Held';
    return AnimatedContainer(
      duration: MeropeTokens.durationNormal,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isHeld ? tokens.onlineStatus : tokens.secondary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isHeld ? tokens.onlineStatus : tokens.secondary).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: MeropeTokens.durationNormal,
            child: Icon(isHeld ? Icons.lock_clock : Icons.check_circle, key: ValueKey(isHeld), color: isHeld ? tokens.onlineStatus : tokens.secondary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHeld ? "Funds in Secure Hold" : "Transaction Completed",
                  style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "ID: ${escrow.id}",
                  style: TextStyle(color: tokens.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTimeline(EscrowStage activeStage, MeropeColorTokens tokens) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _stageAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _stageAnimation.value,
            child: Transform.translate(offset: Offset(0, 20 * (1 - _stageAnimation.value)), child: child),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            children: EscrowStage.values.map((stage) {
              final isCompleted = stage.index <= activeStage.index;
              final isLast = stage == EscrowStage.completed;
              return Expanded(
                child: Row(
                  children: [
                    _buildNode(stage, isCompleted, tokens),
                    if (!isLast) _buildConnector(isCompleted, tokens),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNode(EscrowStage stage, bool isCompleted, MeropeColorTokens tokens) {
    final color = isCompleted ? tokens.primary : tokens.textSecondary.withValues(alpha: 0.3);
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
          child: isCompleted ? Icon(Icons.check, size: 14, color: Colors.white) : null,
        ),
        const SizedBox(height: 8),
        Text(stage.name.toUpperCase(), style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildConnector(bool isCompleted, MeropeColorTokens tokens) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: isCompleted ? tokens.primary : tokens.textSecondary.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildCountdownTimer(MeropeColorTokens tokens, DateTime autoReleaseAt) {
    _remaining ??= autoReleaseAt.difference(DateTime.now());
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      final remaining = autoReleaseAt.difference(DateTime.now());
      if (remaining.isNegative) {
        timer.cancel();
        setState(() {});
        return;
      }
      setState(() {});
    });
    final remaining = autoReleaseAt.difference(DateTime.now());
    final isExpired = remaining.isNegative;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.surfaceVariant,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: tokens.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isExpired ? 'Auto-release pending' : 'Auto-release in ${_formatDuration(remaining)}',
              style: TextStyle(color: tokens.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (days > 0) return '$days d ${hours} h';
    if (hours > 0) return '$hours h ${minutes} m';
    return '$minutes m ${seconds} s';
  }

  Widget _buildDetailSection(String label, String value, MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: tokens.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: tokens.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showDisputeSheet(BuildContext context, MeropeColorTokens tokens) {
    final reasonController = TextEditingController();
    final evidenceController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tokens.surface,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Open Dispute', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tokens.textPrimary)),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(labelText: 'Reason', labelStyle: TextStyle(color: tokens.textSecondary)),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: evidenceController,
                  decoration: InputDecoration(labelText: 'Evidence URL (optional)', labelStyle: TextStyle(color: tokens.textSecondary)),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      MeropeHaptics.heavyImpact();
                      await ref.read(escrowDetailsProvider(widget.escrowId).notifier).openDispute(reasonController.text, evidenceUrl: evidenceController.text.isEmpty ? null : evidenceController.text);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: tokens.dndStatus, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
                    child: const Text("Submit Dispute"),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
