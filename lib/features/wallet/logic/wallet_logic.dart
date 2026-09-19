import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:merope_core/data/database/database_provider.dart';
import 'package:merope_core/data/services/connectivity_service.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import '../domain/models/transaction_model.dart';
import '../repository/wallet_repository.dart';

enum CircuitState { closed, open, halfOpen }

class RetryOptions {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffFactor;
  const RetryOptions(
      {this.maxAttempts = 3,
      this.initialDelay = const Duration(milliseconds: 300),
      this.backoffFactor = 2.0});
}

Future<T> withRetry<T>(Future<T> Function() fn, {RetryOptions? options}) async {
  final opts = options ?? const RetryOptions();
  int attempt = 0;
  Duration delay = opts.initialDelay;
  while (true) {
    try {
      return await fn();
    } catch (e) {
      attempt++;
      if (attempt >= opts.maxAttempts) rethrow;
      await Future.delayed(delay);
      delay = Duration(
          milliseconds: (delay.inMilliseconds * opts.backoffFactor).round());
    }
  }
}

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  final db = ref.watch(meropeDatabaseProvider);
  return DriftWalletRepository(db);
});

class WalletController extends AsyncNotifier<double> {
  static final ApiClient _api = ApiClient();

  @override
  FutureOr<double> build() async {
    final result = await withRetry(() => _api.get<dynamic>('/finance/balance'));
    if (result.isError) {
      throw StateError('Failed to load wallet balance');
    }
    final data = result.data;
    if (data is! Map) throw StateError('Invalid wallet response');
    final value = data['balance'];
    return value is num ? value.toDouble() : double.tryParse('$value') ?? 0.0;
  }

  Future<void> refresh() async {
    MeropeHaptics.lightImpact();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await withRetry(() => _api.get<dynamic>('/finance/balance'));
      if (result.isError) throw StateError('Failed to refresh wallet balance');
      final data = result.data;
      if (data is! Map) throw StateError('Invalid wallet response');
      final value = data['balance'];
      return value is num ? value.toDouble() : double.tryParse('$value') ?? 0.0;
    });
    _invalidateTransactions();
  }

  void _invalidateTransactions() {
    ref.invalidate(transactionsProvider);
  }
}

final walletControllerProvider =
    AsyncNotifierProvider<WalletController, double>(WalletController.new);

final transactionsProvider =
    FutureProvider<List<MeropeTransaction>>((ref) async {
  final result = await withRetry(
      () => ApiClient().get<dynamic>('/finance/transactions'));
  if (result.isError) throw StateError('Failed to load transactions');
  final data = result.data;
  if (data is! Map) return const <MeropeTransaction>[];
  final raw = data['transactions'];
  if (raw is! List) return const <MeropeTransaction>[];
  return raw
      .whereType<Map>()
      .map((entry) => MeropeTransaction.fromJson(
            Map<String, dynamic>.from(entry),
          ))
      .toList(growable: false);
});

class CircuitBreaker {
  int _failures = 0;
  DateTime? _nextRetry;
  CircuitState _state = CircuitState.closed;
  static const _failureThreshold = 5;
  static const _recoveryTimeout = Duration(seconds: 30);

  CircuitState get state => _state;

  Future<T> execute<T>(Future<T> Function() fn) async {
    if (_state == CircuitState.open) {
      if (_nextRetry != null && DateTime.now().isAfter(_nextRetry!)) {
        _state = CircuitState.halfOpen;
      } else {
        throw Exception('Circuit breaker open');
      }
    }
    try {
      final result = await fn();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }

  void _onSuccess() {
    _failures = 0;
    _state = CircuitState.closed;
    _nextRetry = null;
  }

  void _onFailure() {
    _failures++;
    if (_failures >= _failureThreshold) {
      _state = CircuitState.open;
      _nextRetry = DateTime.now().add(_recoveryTimeout);
    }
  }
}

final circuitBreakerProvider =
    Provider<CircuitBreaker>((ref) => CircuitBreaker());

final walletWebSocketProvider = StreamProvider.autoDispose<double>((ref) {
  final controller = StreamController<double>();
  Timer? timer;

  Future<void> poll() async {
    final result = await ApiClient().get<dynamic>('/finance/balance');
    if (result.isError) return;
    final data = result.data;
    if (data is! Map) return;
    final value = data['balance'];
    final balance = value is num ? value.toDouble() : double.tryParse('$value');
    if (balance != null && !controller.isClosed) {
      controller.add(balance);
    }
  }

  poll();
  timer = Timer.periodic(const Duration(seconds: 10), (_) => poll());

  ref.onDispose(() {
    timer?.cancel();
    controller.close();
  });
  return controller.stream;
});
