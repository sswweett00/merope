import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../data/models/suspicious_account.dart';
import '../data/models/moderation_action_request.dart';
import '../data/repositories/moderation_repository.dart';
import '../data/repositories/moderation_repository_impl.dart';
import '../data/datasources/moderation_remote_datasource.dart';
import '../data/datasources/moderation_local_datasource.dart';
import '../data/database/moderation_database.dart';

enum ModerationCategoryFilter { all, bot, spam, harassment, impersonation, csam, copyright, misinformation, coordinatedInauthentic }

class ModerationFilterState {
  final ModerationCategoryFilter category;
  final RiskLevel? riskLevel;
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  const ModerationFilterState({
    this.category = ModerationCategoryFilter.all,
    this.riskLevel,
    this.searchQuery,
    this.startDate,
    this.endDate,
  });

  ModerationFilterState copyWith({
    ModerationCategoryFilter? category,
    RiskLevel? riskLevel,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ModerationFilterState(
      category: category ?? this.category,
      riskLevel: riskLevel ?? this.riskLevel,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  ModerationReason? get reason {
    if (category == ModerationCategoryFilter.all) return null;
    return switch (category) {
      ModerationCategoryFilter.bot => ModerationReason.bot,
      ModerationCategoryFilter.spam => ModerationReason.spam,
      ModerationCategoryFilter.harassment => ModerationReason.harassment,
      ModerationCategoryFilter.impersonation => ModerationReason.impersonation,
      ModerationCategoryFilter.csam => ModerationReason.csam,
      ModerationCategoryFilter.copyright => ModerationReason.copyright,
      ModerationCategoryFilter.misinformation => ModerationReason.misinformation,
      ModerationCategoryFilter.coordinatedInauthentic => ModerationReason.coordinatedInauthentic,
      ModerationCategoryFilter.all => null,
    };
  }
}

final moderationFiltersProvider = StateProvider<ModerationFilterState>((ref) => const ModerationFilterState());

class ModerationQueueState {
  final List<ModerationQueueItem> items;
  final String? nextCursor;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool isLoadingMore;
  final bool hasMore;
  final Map<String, int> metrics;
  final int? selectedIndex;

  const ModerationQueueState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.metrics = const {},
    this.selectedIndex,
  });

  ModerationQueueState copyWith({
    List<ModerationQueueItem>? items,
    String? nextCursor,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? isLoadingMore,
    bool? hasMore,
    Map<String, int>? metrics,
    int? selectedIndex,
  }) {
    return ModerationQueueState(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      metrics: metrics ?? this.metrics,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class ModerationQueueNotifier extends AsyncNotifier<ModerationQueueState> {
  static const int _maxRetries = 3;
  CancelToken? _cancelToken;

  @override
  Future<ModerationQueueState> build() async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final filters = ref.watch(moderationFiltersProvider);
    return _fetchQueue(forceRefresh: true, filters: filters);
  }

  Future<ModerationQueueState> _fetchQueue({
    bool forceRefresh = false,
    required ModerationFilterState filters,
  }) async {
    state = AsyncValue.data(const ModerationQueueState(isLoading: true));

    final repository = ref.read(moderationRepositoryProvider);
    int attempt = 0;

    while (attempt < _maxRetries) {
      try {
        final page = await repository.getQueuePage(
          cursor: forceRefresh ? null : state.value?.nextCursor,
          limit: 20,
          reason: filters.reason,
          riskLevel: filters.riskLevel,
          searchQuery: filters.searchQuery,
          startDate: filters.startDate,
          endDate: filters.endDate,
          forceRefresh: forceRefresh,
        );

        final newItems = forceRefresh ? page.items : [...state.valueOrNull?.items ?? [], ...page.items];
        final result = ModerationQueueState(
          items: newItems,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          metrics: page.metrics,
        );
        state = AsyncValue.data(result);
        return result;
      } catch (e) {
        attempt++;
        if (attempt >= _maxRetries) {
          final errorState = ModerationQueueState(
            items: state.valueOrNull?.items ?? [],
            hasError: true,
            errorMessage: e.toString(),
            nextCursor: state.valueOrNull?.nextCursor,
            metrics: state.valueOrNull?.metrics ?? const {},
          );
          state = AsyncValue.data(errorState);
          return errorState;
        }
        await Future.delayed(Duration(milliseconds: 500 * (1 << (attempt - 1))));
      }
    }

    return state.valueOrNull ?? const ModerationQueueState();
  }

  void updateItems(List<ModerationQueueItem> items) {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(items: items));
    }
  }

  Future<void> refresh() async {
    final filters = ref.read(moderationFiltersProvider);
    await _fetchQueue(forceRefresh: true, filters: filters);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    final filters = ref.read(moderationFiltersProvider);
    final result = await _fetchQueue(forceRefresh: false, filters: filters);
    state = AsyncValue.data(result.copyWith(isLoadingMore: false));
  }

  void setFilters(ModerationFilterState filters) {
    ref.read(moderationFiltersProvider.notifier).state = filters;
    refresh();
  }

  Future<void> dispose() async {
    _cancelToken?.cancel();
  }
}

final moderationQueueProvider = AsyncNotifierProvider<ModerationQueueNotifier, ModerationQueueState>(ModerationQueueNotifier.new);

class ModerationActionState {
  final bool isBanning;
  final bool isMarkingSafe;
  final bool isEscalating;
  final bool isBulkProcessing;
  final String? errorMessage;
  final Map<String, String?> rollbackState;

  const ModerationActionState({
    this.isBanning = false,
    this.isMarkingSafe = false,
    this.isEscalating = false,
    this.isBulkProcessing = false,
    this.errorMessage,
    this.rollbackState = const {},
  });

  ModerationActionState copyWith({
    bool? isBanning,
    bool? isMarkingSafe,
    bool? isEscalating,
    bool? isBulkProcessing,
    String? errorMessage,
    Map<String, String?>? rollbackState,
  }) {
    return ModerationActionState(
      isBanning: isBanning ?? this.isBanning,
      isMarkingSafe: isMarkingSafe ?? this.isMarkingSafe,
      isEscalating: isEscalating ?? this.isEscalating,
      isBulkProcessing: isBulkProcessing ?? this.isBulkProcessing,
      errorMessage: errorMessage ?? this.errorMessage,
      rollbackState: rollbackState ?? this.rollbackState,
    );
  }
}

class ModerationActionsController extends StateNotifier<ModerationActionState> {
  final Ref ref;
  final IModerationRepository repository;
  CancelToken? _cancelToken;

  ModerationActionsController(this.ref, this.repository)
      : super(const ModerationActionState());

  void _cancelPending() {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
  }

  Future<void> _applyOptimistic(List<ModerationQueueItem> optimisticItems) async {
    final notifier = ref.read(moderationQueueProvider.notifier);
    if (notifier is ModerationQueueNotifier) {
      notifier.updateItems(optimisticItems);
    }
  }

  Future<void> banUser(String userId, {String? moderatorNote}) async {
    MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
    _cancelPending();
    final previousItems = ref.read(moderationQueueProvider).valueOrNull?.items ?? [];

    try {
      state = state.copyWith(isBanning: true, errorMessage: null);
      final optimisticItems = previousItems.map((item) {
        if (item.userId == userId) {
          return item.copyWith(lastAction: LastAction.banned, moderatorNote: moderatorNote, updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(optimisticItems);

      await repository.banUser(userId: userId, moderatorNote: moderatorNote);

      final currentState = ref.read(moderationQueueProvider);
      if (currentState.hasValue) {
        final updated = currentState.value!.items.where((item) => item.userId != userId).toList();
        await _applyOptimistic(updated);
      }
    } catch (e) {
      final rollbackItems = previousItems.map((item) {
        if (item.userId == userId) {
          return item.copyWith(updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(rollbackItems);
      state = state.copyWith(isBanning: false, errorMessage: e.toString());
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(errorMessage: null);
      return;
    }
    state = state.copyWith(isBanning: false);
  }

  Future<void> markSafe(String userId, {String? moderatorNote}) async {
    MeropeHaptics.trigger(MeropeTokens.hapticLight);
    _cancelPending();
    final previousItems = ref.read(moderationQueueProvider).valueOrNull?.items ?? [];

    try {
      state = state.copyWith(isMarkingSafe: true, errorMessage: null);
      final optimisticItems = previousItems.map((item) {
        if (item.userId == userId) {
          return item.copyWith(lastAction: LastAction.safe, moderatorNote: moderatorNote, updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(optimisticItems);

      await repository.markSafe(userId: userId, moderatorNote: moderatorNote);

      final currentState = ref.read(moderationQueueProvider);
      if (currentState.hasValue) {
        final updated = currentState.value!.items.where((item) => item.userId != userId).toList();
        await _applyOptimistic(updated);
      }
    } catch (e) {
      final rollbackItems = previousItems.map((item) {
        if (item.userId == userId) {
          return item.copyWith(updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(rollbackItems);
      state = state.copyWith(isMarkingSafe: false, errorMessage: e.toString());
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(errorMessage: null);
      return;
    }
    state = state.copyWith(isMarkingSafe: false);
  }

  Future<void> escalate(String userId, {String? target, String? moderatorNote}) async {
    MeropeHaptics.trigger(MeropeTokens.hapticMedium);
    _cancelPending();
    final previousItems = ref.read(moderationQueueProvider).valueOrNull?.items ?? [];

    try {
      state = state.copyWith(isEscalating: true, errorMessage: null);
      final optimisticItems = previousItems.map((item) {
        if (item.userId == userId) {
          return item.copyWith(lastAction: LastAction.escalated, moderatorNote: moderatorNote, updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(optimisticItems);

      await repository.escalate(userId: userId, target: target, moderatorNote: moderatorNote);

      final currentState = ref.read(moderationQueueProvider);
      if (currentState.hasValue) {
        final updated = currentState.value!.items.where((item) => item.userId != userId).toList();
        await _applyOptimistic(updated);
      }
    } catch (e) {
      final rollbackItems = previousItems.map((item) {
        if (item.userId == userId) {
          return item.copyWith(updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(rollbackItems);
      state = state.copyWith(isEscalating: false, errorMessage: e.toString());
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(errorMessage: null);
      return;
    }
    state = state.copyWith(isEscalating: false);
  }

  Future<void> bulkAction(ModerationActionType type, List<String> userIds, {String? moderatorNote}) async {
    MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
    _cancelPending();
    final previousItems = ref.read(moderationQueueProvider).valueOrNull?.items ?? [];
    final targetIds = userIds.toSet();

    try {
      state = state.copyWith(isBulkProcessing: true, errorMessage: null);
      final optimisticItems = previousItems.map((item) {
        if (targetIds.contains(item.userId)) {
          final action = type == ModerationActionType.ban ? LastAction.banned : type == ModerationActionType.escalate ? LastAction.escalated : LastAction.safe;
          return item.copyWith(lastAction: action, moderatorNote: moderatorNote, updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(optimisticItems);

      await repository.bulkAction(type: type, userIds: userIds, moderatorNote: moderatorNote);

      final currentState = ref.read(moderationQueueProvider);
      if (currentState.hasValue) {
        final updated = currentState.value!.items.where((item) => !targetIds.contains(item.userId)).toList();
        await _applyOptimistic(updated);
      }
    } catch (e) {
      final rollbackItems = previousItems.map((item) {
        if (targetIds.contains(item.userId)) {
          return item.copyWith(updatedAt: DateTime.now());
        }
        return item;
      }).toList();
      await _applyOptimistic(rollbackItems);
      state = state.copyWith(isBulkProcessing: false, errorMessage: e.toString());
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(errorMessage: null);
      return;
    }
    state = state.copyWith(isBulkProcessing: false);
  }
}

final moderationRepositoryProvider = Provider<IModerationRepository>((ref) {
  final apiClient = ApiClient();
  final dio = apiClient.dio;
  return ModerationRepositoryImpl(
    remoteDataSource: ModerationRemoteDataSourceImpl(dio: dio),
    localDataSource: ModerationLocalDataSourceImpl(ref.read(moderationDatabaseProvider)),
  );
});

final moderationActionsControllerProvider = StateNotifierProvider<ModerationActionsController, ModerationActionState>((ref) {
  final repository = ref.watch(moderationRepositoryProvider);
  return ModerationActionsController(ref, repository);
});

class SuspiciousAccountsNotifier extends AsyncNotifier<List<SuspiciousAccount>> {
  @override
  FutureOr<List<SuspiciousAccount>> build() async {
    // Simulated fetch
    return [];
  }

  Future<void> banAccount(String userId) async {
    // Implementation
  }

  Future<void> markAsSafe(String userId) async {
    // Implementation
  }
}

final suspiciousAccountsControllerProvider = AsyncNotifierProvider<SuspiciousAccountsNotifier, List<SuspiciousAccount>>(SuspiciousAccountsNotifier.new);

final moderationDatabaseProvider = Provider<ModerationDatabase>((ref) {
  return ModerationDatabase();
});
