import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import '../logic/moderation_provider.dart';
import '../data/models/suspicious_account.dart';
import '../data/models/moderation_action_request.dart';
import 'screens/moderation_detail_screen.dart';

class ModerationScreen extends ConsumerStatefulWidget {
  const ModerationScreen({super.key});

  @override
  ConsumerState<ModerationScreen> createState() => _ModerationScreenState();
}

class _ModerationScreenState extends ConsumerState<ModerationScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _isBulkMode = false;
  final Set<String> _selectedIds = <String>{};
  final ScrollController _scrollController = ScrollController();
  static const int _itemExtent = 160;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(moderationQueueProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(moderationFiltersProvider.notifier).state = ref
          .read(moderationFiltersProvider)
          .copyWith(searchQuery: query.isEmpty ? null : query);
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(moderationQueueProvider.notifier).refresh();
  }

  void _toggleBulkMode() {
    MeropeHaptics.trigger(MeropeTokens.hapticSelection);
    setState(() {
      _isBulkMode = !_isBulkMode;
      if (!_isBulkMode) _selectedIds.clear();
    });
  }

  void _toggleSelect(String userId) {
    MeropeHaptics.trigger(MeropeTokens.hapticSoft);
    setState(() {
      if (_selectedIds.contains(userId)) {
        _selectedIds.remove(userId);
      } else {
        _selectedIds.add(userId);
      }
    });
  }

  Future<void> _performBulkAction(ModerationActionType type) async {
    MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
    await ref
        .read(moderationActionsControllerProvider.notifier)
        .bulkAction(type, _selectedIds.toList(), moderatorNote: 'Bulk action');
    setState(() {
      _isBulkMode = false;
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tokens = MeropeColorTokens.darkDefault();
    final queueAsync = ref.watch(moderationQueueProvider);
    final actionState = ref.watch(moderationActionsControllerProvider);
    final filters = ref.watch(moderationFiltersProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(MeropeTokens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Moderasyon ve Raporlar',
                          style: TextStyle(
                            fontSize: MeropeTokens.fontSizeXl,
                            fontWeight: FontWeight.bold,
                            color: tokens.textPrimary,
                          ),
                        ),
                      ),
                      if (_isBulkMode)
                        TextButton(
                          onPressed: _toggleBulkMode,
                          child: Text('İptal',
                              style: TextStyle(color: tokens.textSecondary)),
                        )
                      else
                        IconButton(
                          onPressed: _toggleBulkMode,
                          icon: Icon(Icons.checklist_rounded,
                              color: tokens.textSecondary),
                        ),
                    ],
                  ),
                  const SizedBox(height: MeropeTokens.space16),
                  _ModerationMetricsRow(
                      metrics: queueAsync.valueOrNull?.metrics ?? const {}),
                  const SizedBox(height: MeropeTokens.space16),
                  _CategoryTabBar(filters: filters, tokens: tokens),
                  const SizedBox(height: MeropeTokens.space12),
                  _SearchBar(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      tokens: tokens),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: tokens.primary,
                child: queueAsync.when(
                  loading: () => _buildSkeleton(tokens),
                  error: (error, _) =>
                      _buildErrorState(tokens, error.toString()),
                  data: (state) {
                    if (state.items.isEmpty && !state.isLoading) {
                      return _buildEmptyState(tokens);
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: MeropeTokens.space24),
                      itemCount: state.items.length + (state.hasMore ? 1 : 0),
                      itemExtent: _itemExtent.toDouble(),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                                child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))),
                          );
                        }
                        final item = state.items[index];
                        return _ModerationQueueCard(
                          key: ValueKey(item.userId),
                          item: item,
                          tokens: tokens,
                          isSelected: _selectedIds.contains(item.userId),
                          isBulkMode: _isBulkMode,
                          onSelect: () => _toggleSelect(item.userId),
                          onTap: () {
                            MeropeHaptics.trigger(MeropeTokens.hapticLight);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ModerationDetailScreen(item: item),
                              ),
                            );
                          },
                          onDismissedLeft: () => ref
                              .read(
                                  moderationActionsControllerProvider.notifier)
                              .markSafe(item.userId),
                          onDismissedRight: () => ref
                              .read(
                                  moderationActionsControllerProvider.notifier)
                              .banUser(item.userId),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            if (_isBulkMode && _selectedIds.isNotEmpty)
              _BulkActionBar(
                selectedCount: _selectedIds.length,
                onBan: () => _performBulkAction(ModerationActionType.ban),
                onSafe: () => _performBulkAction(ModerationActionType.markSafe),
                onEscalate: () =>
                    _performBulkAction(ModerationActionType.escalate),
                tokens: tokens,
              ),
            if (actionState.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: MeropeTokens.space24,
                    vertical: MeropeTokens.space12),
                color: tokens.error.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: tokens.error, size: 20),
                    const SizedBox(width: MeropeTokens.space8),
                    Expanded(
                      child: Text(actionState.errorMessage!,
                          style: TextStyle(
                              color: tokens.error,
                              fontSize: MeropeTokens.fontSizeSm)),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(moderationActionsControllerProvider.notifier),
                      child: Text('Dismiss',
                          style: TextStyle(color: tokens.primary)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(MeropeColorTokens tokens) {
    return Shimmer.fromColors(
      baseColor: tokens.surface,
      highlightColor: tokens.surfaceVariant,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: MeropeTokens.space24),
        itemCount: 5,
        itemExtent: _itemExtent.toDouble(),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: MeropeTokens.space16),
          padding: const EdgeInsets.all(MeropeTokens.space16),
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Expanded(child: Container(height: 12, color: Colors.white)),
              ]),
              const SizedBox(height: 12),
              Container(
                  width: double.infinity, height: 10, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 200, height: 10, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(MeropeColorTokens tokens, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MeropeTokens.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 48, color: tokens.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: MeropeTokens.space16),
            Text('Bağlantı Hatası',
                style: TextStyle(
                    color: tokens.textPrimary,
                    fontSize: MeropeTokens.fontSizeLg,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: MeropeTokens.space8),
            Text(error,
                textAlign: TextAlign.center,
                style: TextStyle(color: tokens.textSecondary)),
            const SizedBox(height: MeropeTokens.space24),
            MeropeButton(
              text: 'Tekrar Dene',
              onPressed: _handleRefresh,
              style: MeropeButtonStyle.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(MeropeColorTokens tokens) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MeropeTokens.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded,
                size: 48, color: tokens.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: MeropeTokens.space16),
            Text('Kuyruk Boş',
                style: TextStyle(
                    color: tokens.textPrimary,
                    fontSize: MeropeTokens.fontSizeLg,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: MeropeTokens.space8),
            Text('Şu anda moderasyon bekleyen içerik yok.',
                textAlign: TextAlign.center,
                style: TextStyle(color: tokens.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ModerationMetricsRow extends StatelessWidget {
  final Map<String, int> metrics;

  const _ModerationMetricsRow({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final tokens = MeropeColorTokens.darkDefault();
    final itemsPerHour = metrics['items_per_hour'] ?? 0;
    final accuracyRate = metrics['accuracy_rate'] ?? 0;
    final pendingCount = metrics['pending_count'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: _MetricChip(
            label: 'Saatteki İşlem',
            value: '$itemsPerHour',
            icon: Icons.speed_rounded,
            tokens: tokens,
          ),
        ),
        const SizedBox(width: MeropeTokens.space8),
        Expanded(
          child: _MetricChip(
            label: 'Doğruluk Oranı',
            value: '%$accuracyRate',
            icon: Icons.verified_rounded,
            tokens: tokens,
          ),
        ),
        const SizedBox(width: MeropeTokens.space8),
        Expanded(
          child: _MetricChip(
            label: 'Bekleyen',
            value: '$pendingCount',
            icon: Icons.pending_rounded,
            tokens: tokens,
          ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final MeropeColorTokens tokens;

  const _MetricChip(
      {required this.label,
      required this.value,
      required this.icon,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: MeropeTokens.space12, vertical: MeropeTokens.space8),
      decoration: BoxDecoration(
        color: tokens.surfaceVariant,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: tokens.primary),
          const SizedBox(width: MeropeTokens.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value,
                    style: TextStyle(
                        color: tokens.textPrimary,
                        fontSize: MeropeTokens.fontSizeSm,
                        fontWeight: FontWeight.bold)),
                Text(label,
                    style:
                        TextStyle(color: tokens.textSecondary, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabBar extends ConsumerWidget {
  final ModerationFilterState filters;
  final MeropeColorTokens tokens;

  const _CategoryTabBar({required this.filters, required this.tokens});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _CategoryChip(
            label: 'Tümü',
            isActive: filters.category == ModerationCategoryFilter.all,
            onTap: () => _updateFilter(ref, ModerationCategoryFilter.all),
            tokens: tokens,
          ),
          const SizedBox(width: MeropeTokens.space8),
          _CategoryChip(
            label: 'Bot',
            isActive: filters.category == ModerationCategoryFilter.bot,
            onTap: () => _updateFilter(ref, ModerationCategoryFilter.bot),
            tokens: tokens,
          ),
          const SizedBox(width: MeropeTokens.space8),
          _CategoryChip(
            label: 'Spam',
            isActive: filters.category == ModerationCategoryFilter.spam,
            onTap: () => _updateFilter(ref, ModerationCategoryFilter.spam),
            tokens: tokens,
          ),
          const SizedBox(width: MeropeTokens.space8),
          _CategoryChip(
            label: 'Taciz',
            isActive: filters.category == ModerationCategoryFilter.harassment,
            onTap: () =>
                _updateFilter(ref, ModerationCategoryFilter.harassment),
            tokens: tokens,
          ),
          const SizedBox(width: MeropeTokens.space8),
          _CategoryChip(
            label: 'Sahtecilik',
            isActive:
                filters.category == ModerationCategoryFilter.impersonation,
            onTap: () =>
                _updateFilter(ref, ModerationCategoryFilter.impersonation),
            tokens: tokens,
          ),
        ],
      ),
    );
  }

  void _updateFilter(WidgetRef ref, ModerationCategoryFilter category) {
    MeropeHaptics.trigger(MeropeTokens.hapticSoft);
    ref.read(moderationFiltersProvider.notifier).state =
        ref.read(moderationFiltersProvider).copyWith(category: category);
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final MeropeColorTokens tokens;

  const _CategoryChip(
      {required this.label,
      required this.isActive,
      required this.onTap,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: MeropeTokens.space12, vertical: MeropeTokens.space6),
        decoration: BoxDecoration(
          color: isActive ? tokens.primary : tokens.surfaceVariant,
          borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
          border: Border.all(color: isActive ? tokens.primary : tokens.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? tokens.onPrimary : tokens.textSecondary,
            fontSize: MeropeTokens.fontSizeXs,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final MeropeColorTokens tokens;

  const _SearchBar(
      {required this.controller,
      required this.onChanged,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
          color: tokens.textPrimary, fontSize: MeropeTokens.fontSizeSm),
      decoration: InputDecoration(
        hintText: 'Kullanıcı ara...',
        hintStyle: TextStyle(
            color: tokens.textSecondary.withValues(alpha: 0.5),
            fontSize: MeropeTokens.fontSizeSm),
        prefixIcon:
            Icon(Icons.search_rounded, color: tokens.textSecondary, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: Icon(Icons.clear_rounded,
                    color: tokens.textSecondary, size: 18),
              )
            : null,
        filled: true,
        fillColor: tokens.surfaceVariant,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
            borderSide: BorderSide(color: tokens.primary, width: 1)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: MeropeTokens.space16, vertical: MeropeTokens.space10),
      ),
    );
  }
}

class _ModerationQueueCard extends StatelessWidget {
  final ModerationQueueItem item;
  final MeropeColorTokens tokens;
  final bool isSelected;
  final bool isBulkMode;
  final VoidCallback? onSelect;
  final VoidCallback? onTap;
  final VoidCallback? onDismissedLeft;
  final VoidCallback? onDismissedRight;

  const _ModerationQueueCard({
    super.key,
    required this.item,
    required this.tokens,
    required this.isSelected,
    required this.isBulkMode,
    this.onSelect,
    this.onTap,
    this.onDismissedLeft,
    this.onDismissedRight,
  });

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(item.riskLevel);
    final reasonLabel = _reasonLabel(item.reason);

    final card = RepaintBoundary(
      child: Dismissible(
        key: ValueKey(item.userId),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            MeropeHaptics.trigger(MeropeTokens.hapticMedium);
            onDismissedLeft?.call();
            return false;
          } else if (direction == DismissDirection.endToStart) {
            MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
            onDismissedRight?.call();
            return false;
          }
          return false;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: MeropeTokens.space20),
          decoration: BoxDecoration(
            color: tokens.secondary,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          ),
          child: Icon(Icons.check_circle_rounded,
              color: tokens.onSecondary, size: 28),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: MeropeTokens.space20),
          decoration: BoxDecoration(
            color: tokens.error,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          ),
          child: Icon(Icons.block_rounded, color: tokens.onError, size: 28),
        ),
        child: MeropeCard(
          color: isSelected
              ? tokens.primary.withValues(alpha: 0.08)
              : tokens.surface,
          padding: const EdgeInsets.all(MeropeTokens.space16),
          borderRadius: MeropeTokens.radiusMd,
          hasAtmosphere: item.riskLevel == RiskLevel.critical,
          onTap: onTap,
          child: Row(
            children: [
              if (isBulkMode)
                Padding(
                  padding: const EdgeInsets.only(right: MeropeTokens.space12),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onSelect?.call(),
                    activeColor: tokens.primary,
                    checkColor: tokens.onPrimary,
                  ),
                ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.username.isNotEmpty
                        ? item.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: MeropeTokens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.displayName,
                            style: TextStyle(
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: MeropeTokens.fontSizeSm),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: MeropeTokens.space8),
                        _SeverityBadge(
                            riskLevel: item.riskLevel, tokens: tokens),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('@${item.username}',
                            style: TextStyle(
                                color: tokens.textSecondary, fontSize: 12)),
                        const SizedBox(width: MeropeTokens.space8),
                        Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                                color: tokens.textSecondary,
                                shape: BoxShape.circle)),
                        const SizedBox(width: MeropeTokens.space8),
                        Text(reasonLabel,
                            style: TextStyle(
                                color: tokens.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Güven: ${(item.trustScore * 100).toInt()}%',
                            style: TextStyle(
                                color: tokens.textSecondary, fontSize: 11)),
                        const SizedBox(width: MeropeTokens.space8),
                        Text('Bot: ${(item.botProbability * 100).toInt()}%',
                            style: TextStyle(
                                color: tokens.textSecondary, fontSize: 11)),
                        if (item.isAppealed) ...[
                          const SizedBox(width: MeropeTokens.space8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: tokens.secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('İtiraz',
                                style: TextStyle(
                                    color: tokens.secondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: MeropeTokens.space12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${item.reportCount}',
                    style: TextStyle(
                        color: tokens.error,
                        fontSize: MeropeTokens.fontSizeLg,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Rapor',
                      style:
                          TextStyle(color: tokens.textSecondary, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(bottom: MeropeTokens.space12),
        child: card);
  }

  Color _riskColor(RiskLevel level) {
    return switch (level) {
      RiskLevel.low => tokens.secondary,
      RiskLevel.medium => tokens.idleStatus,
      RiskLevel.high => const Color(0xFFF0B232),
      RiskLevel.critical => tokens.error,
    };
  }

  String _reasonLabel(ModerationReason reason) {
    return switch (reason) {
      ModerationReason.bot => 'Bot',
      ModerationReason.spam => 'Spam',
      ModerationReason.harassment => 'Taciz',
      ModerationReason.impersonation => 'Sahtecilik',
      ModerationReason.csam => 'CSAM',
      ModerationReason.copyright => 'Telif Hakkı',
      ModerationReason.misinformation => 'Yanlış Bilgi',
      ModerationReason.coordinatedInauthentic => 'Koordinasyon',
    };
  }
}

class _SeverityBadge extends StatelessWidget {
  final RiskLevel riskLevel;
  final MeropeColorTokens tokens;

  const _SeverityBadge({required this.riskLevel, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final color = switch (riskLevel) {
      RiskLevel.low => tokens.secondary,
      RiskLevel.medium => tokens.idleStatus,
      RiskLevel.high => const Color(0xFFF0B232),
      RiskLevel.critical => tokens.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        riskLevel.name.toUpperCase(),
        style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5),
      ),
    );
  }
}

class _BulkActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onBan;
  final VoidCallback onSafe;
  final VoidCallback onEscalate;
  final MeropeColorTokens tokens;

  const _BulkActionBar(
      {required this.selectedCount,
      required this.onBan,
      required this.onSafe,
      required this.onEscalate,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: MeropeTokens.space24, vertical: MeropeTokens.space12),
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.border)),
        boxShadow: [MeropeTokens.shadowMd],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Text('$selectedCount seçili',
                style: TextStyle(
                    color: tokens.textPrimary, fontWeight: FontWeight.w600)),
            const Spacer(),
            MeropeButton(
              text: 'Güvenli',
              onPressed: onSafe,
              style: MeropeButtonStyle.secondary,
              icon: Icons.check_rounded,
            ),
            const SizedBox(width: MeropeTokens.space8),
            MeropeButton(
              text: 'Yükselt',
              onPressed: onEscalate,
              style: MeropeButtonStyle.secondary,
              icon: Icons.arrow_upward_rounded,
            ),
            const SizedBox(width: MeropeTokens.space8),
            MeropeButton(
              text: 'Yasakla',
              onPressed: onBan,
              style: MeropeButtonStyle.danger,
              icon: Icons.block_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
