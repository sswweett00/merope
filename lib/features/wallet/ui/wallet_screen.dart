import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import 'package:merope_core/data/services/api_client.dart';
import '../logic/wallet_logic.dart';
import '../logic/catalyst_logic.dart';
import '../domain/models/transaction_model.dart';

enum TxFilter { all, sent, received, pending, failed }

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  TxFilter _filter = TxFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ConfettiController _confettiController = ConfettiController();

  @override
  void dispose() {
    _searchController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final balanceAsync = ref.watch(walletControllerProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final catalystAsync = ref.watch(catalystControllerProvider);

    final filteredTransactions = _applyFilter(
        _filter, _searchQuery, transactionsAsync.value ?? const []);

    return Scaffold(
      backgroundColor: tokens.background,
      body: RefreshIndicator(
        onRefresh: () => ref.read(walletControllerProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(MeropeTokens.space24),
          children: [
            RepaintBoundary(
              child: Text(
                'My Wallet',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildCatalystBanner(tokens, catalystAsync.value),
              crossFadeState: catalystAsync.value?.isActive == true
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: MeropeTokens.durationNormal,
            ),
            const SizedBox(height: 16),
            RepaintBoundary(
              child: MeropeCard(
                color: tokens.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Balance',
                        style: TextStyle(color: tokens.textSecondary)),
                    const SizedBox(height: 8),
                    balanceAsync.when(
                      data: (balance) => TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: balance, end: balance),
                        duration: MeropeTokens.durationSlow,
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(2)} TRY',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: tokens.primary),
                          );
                        },
                        onEnd: () => _confettiController.play(),
                      ),
                      loading: () => const _BalanceSkeleton(),
                      error: (err, _) => Text('Error',
                          style: TextStyle(color: tokens.dndStatus)),
                    ),
                    const SizedBox(height: MeropeTokens.space16),
                    Row(
                      children: [
                        Expanded(
                          child: MeropeButton(
                            text: 'Send',
                            onPressed: () {
                              MeropeHaptics.mediumImpact();
                              _showSendSheet(context, tokens);
                            },
                          ),
                        ),
                        const SizedBox(width: MeropeTokens.space12),
                        Expanded(
                          child: MeropeButton(
                            text: 'Receive',
                            style: MeropeButtonStyle.secondary,
                            onPressed: () {
                              MeropeHaptics.mediumImpact();
                              _showReceiveSheet(context, tokens);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MeropeTokens.space16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          MeropeHaptics.selectionClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Merope Pay activated')));
                        },
                        icon:
                            Icon(Icons.qr_code_scanner, color: tokens.primary),
                        label: Text('MEROPE PAY',
                            style: TextStyle(
                                color: tokens.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: tokens.primary.withValues(alpha: 0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: MeropeTokens.space24),
            _buildFilterChips(tokens),
            const SizedBox(height: MeropeTokens.space12),
            _buildSearchBar(tokens),
            const SizedBox(height: MeropeTokens.space12),
            RepaintBoundary(
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary),
              ),
            ),
            const SizedBox(height: MeropeTokens.space12),
            if (filteredTransactions.isEmpty && !transactionsAsync.isLoading)
              _EmptyState(tokens: tokens)
            else
              transactionsAsync.when(
                data: (_) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredTransactions.length,
                  itemExtent: 72,
                  itemBuilder: (context, index) {
                    final tx = filteredTransactions[index];
                    final isCredit = tx.type == TransactionType.credit;
                    return Dismissible(
                      key: Key(tx.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                          color: tokens.dndStatus,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Icon(Icons.archive, color: Colors.white)),
                      secondaryBackground: Container(
                          color: tokens.dndStatus,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Icon(Icons.report, color: Colors.white)),
                      confirmDismiss: (direction) async {
                        MeropeHaptics.heavyImpact();
                        return direction == DismissDirection.endToStart
                            ? true
                            : null;
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: tokens.surface,
                          child: Icon(
                              isCredit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isCredit
                                  ? tokens.primary
                                  : tokens.textSecondary),
                        ),
                        title: Text(tx.description,
                            style: TextStyle(color: tokens.textPrimary)),
                        subtitle: Text(tx.createdAt.toString().substring(0, 16),
                            style: TextStyle(color: tokens.textSecondary)),
                        trailing: Text(
                          '${isCredit ? '+' : '-'}${tx.amount.toStringAsFixed(2)} TRY',
                          style: TextStyle(
                              color: isCredit
                                  ? tokens.primary
                                  : tokens.textPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          MeropeHaptics.lightImpact();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => _TransactionDetailScreen(
                                      transaction: tx, tokens: tokens)));
                        },
                      ),
                    );
                  },
                ),
                loading: () => const _TransactionsSkeleton(),
                error: (err, _) => Center(
                  child: Column(
                    children: [
                      Text('Hata: $err',
                          style: TextStyle(color: tokens.dndStatus)),
                      const SizedBox(height: 12),
                      MeropeButton(
                          text: 'Retry',
                          onPressed: () =>
                              ref.invalidate(transactionsProvider)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalystBanner(
      MeropeColorTokens tokens, CatalystRequirements? reqs) {
    if (reqs == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.diamond, color: tokens.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            'Partner Program Active • Earning Enabled',
            style: TextStyle(
                color: tokens.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(MeropeColorTokens tokens) {
    final chips = [
      (TxFilter.all, 'All'),
      (TxFilter.sent, 'Sent'),
      (TxFilter.received, 'Received'),
      (TxFilter.pending, 'Pending'),
      (TxFilter.failed, 'Failed'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((chip) {
          final isSelected = _filter == chip.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(chip.$2),
              selected: isSelected,
              onSelected: (selected) {
                MeropeHaptics.selectionClick();
                setState(() => _filter = chip.$1);
              },
              selectedColor: tokens.primary.withValues(alpha: 0.2),
              checkmarkColor: tokens.primary,
              labelStyle: TextStyle(
                  color: isSelected ? tokens.primary : tokens.textSecondary),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar(MeropeColorTokens tokens) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search transactions...',
        hintStyle: TextStyle(color: tokens.textSecondary),
        prefixIcon: Icon(Icons.search, color: tokens.textSecondary),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: tokens.textSecondary),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                })
            : null,
        filled: true,
        fillColor: tokens.surface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
            borderSide: BorderSide.none),
      ),
      style: TextStyle(color: tokens.textPrimary),
      onChanged: (value) => setState(() => _searchQuery = value),
    );
  }

  List<MeropeTransaction> _applyFilter(
      TxFilter filter, String query, List<MeropeTransaction> txs) {
    var result = txs;
    switch (filter) {
      case TxFilter.sent:
        result = result.where((t) => t.type == TransactionType.debit).toList();
        break;
      case TxFilter.received:
        result = result.where((t) => t.type == TransactionType.credit).toList();
        break;
      case TxFilter.pending:
        result =
            result.where((t) => t.status == TransactionStatus.pending).toList();
        break;
      case TxFilter.failed:
        result =
            result.where((t) => t.status == TransactionStatus.failed).toList();
        break;
      case TxFilter.all:
        break;
    }
    if (query.isNotEmpty) {
      result = result
          .where(
              (t) => t.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return result;
  }

  void _showSendSheet(BuildContext context, MeropeColorTokens tokens) {
    final recipientController = TextEditingController();
    final amountController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: tokens.surface,
        builder: (ctx) {
          var submitting = false;
          return StatefulBuilder(
            builder: (ctx, setModalState) => Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Send TRY',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary)),
                const SizedBox(height: 16),
                TextField(
                    controller: recipientController,
                    decoration: InputDecoration(
                        labelText: 'Recipient',
                        hintText: 'Enter account ID',
                        labelStyle: TextStyle(color: tokens.textSecondary))),
                const SizedBox(height: 12),
                TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: '0',
                        labelStyle: TextStyle(color: tokens.textSecondary)),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: MeropeButton(
                        text: submitting ? 'Sending...' : 'Confirm Send',
                        onPressed: submitting
                            ? null
                            : () async {
                                final recipient = recipientController.text.trim();
                                final amount = int.tryParse(amountController.text.trim());
                                if (recipient.isEmpty || amount == null || amount <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Enter a valid recipient and amount')),
                                  );
                                  return;
                                }
                                setModalState(() => submitting = true);
                                MeropeHaptics.heavyImpact();
                                final result = await ApiClient().post<dynamic>(
                                  '/finance/transfer',
                                  data: {
                                    'receiver_id': recipient,
                                    'amount': amount,
                                  },
                                );
                                if (!ctx.mounted) return;
                                if (result.isError) {
                                  setModalState(() => submitting = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Transfer failed')),
                                  );
                                  return;
                                }
                                Navigator.pop(ctx);
                                ref.invalidate(walletControllerProvider);
                                ref.invalidate(transactionsProvider);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Transfer completed')),
                                );
                              })),
              ]),
            ),
          );
        }).whenComplete(() {
      recipientController.dispose();
      amountController.dispose();
    });
  }

  void _showReceiveSheet(BuildContext context, MeropeColorTokens tokens) {
    showModalBottomSheet(
        context: context,
        backgroundColor: tokens.surface,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Receive TRY',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary)),
              const SizedBox(height: 16),
              Container(
                  width: 200,
                  height: 200,
                  color: tokens.surfaceVariant,
                  child: const Icon(Icons.qr_code, size: 160)),
              const SizedBox(height: 16),
              SelectableText('merope:me',
                  style: TextStyle(color: tokens.textSecondary)),
              const SizedBox(height: 24),
              SizedBox(
                  width: double.infinity,
                  child: MeropeButton(
                      text: 'Copy Address',
                      style: MeropeButtonStyle.secondary,
                      onPressed: () {
                        MeropeHaptics.lightImpact();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address copied')));
                      })),
            ]),
          );
        });
  }
}

class _BalanceSkeleton extends StatelessWidget {
  const _BalanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E2230),
      highlightColor: const Color(0xFF2B2D31),
      child: Container(
          width: 180,
          height: 36,
          decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(8))),
    );
  }
}

class _TransactionsSkeleton extends StatelessWidget {
  const _TransactionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: const Color(0xFF1E2230),
        highlightColor: const Color(0xFF2B2D31),
        child: Container(
            height: 72,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _EmptyState({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 64, color: tokens.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No transactions found',
              style: TextStyle(color: tokens.textSecondary)),
          const SizedBox(height: 12),
          MeropeButton(
              text: 'Make Your First Transaction',
              style: MeropeButtonStyle.secondary,
              onPressed: () {
                MeropeHaptics.lightImpact();
              }),
        ],
      ),
    );
  }
}

class _TransactionDetailScreen extends StatelessWidget {
  final MeropeTransaction transaction;
  final MeropeColorTokens tokens;
  const _TransactionDetailScreen(
      {required this.transaction, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
          title: const Text('Transaction Details'),
          backgroundColor: tokens.surface,
          foregroundColor: tokens.textPrimary),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Icon(
                    isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 48,
                    color: isCredit ? tokens.primary : tokens.textSecondary)),
            const SizedBox(height: 24),
            _detailRow('Amount', '${transaction.amount.toStringAsFixed(2)} TRY',
                tokens),
            _detailRow(
                'Fee', '${transaction.fee.toStringAsFixed(2)} TRY', tokens),
            _detailRow('Status', transaction.status.name.toUpperCase(), tokens),
            _detailRow('Currency', transaction.currency, tokens),
            if (transaction.category != null)
              _detailRow('Category', transaction.category!, tokens),
            if (transaction.receiptUrl != null)
              _detailRow('Receipt', transaction.receiptUrl!, tokens),
            if (transaction.fraudScore != null)
              _detailRow('Fraud Score',
                  '${(transaction.fraudScore! * 100).toInt()}%', tokens),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: tokens.textSecondary)),
          Text(value,
              style: TextStyle(
                  color: tokens.textPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
