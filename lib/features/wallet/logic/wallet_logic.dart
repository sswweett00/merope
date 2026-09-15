import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:merope_core/data/database/database_provider.dart';
import 'package:merope_core/data/services/connectivity_service.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import '../domain/models/transaction_model.dart';
import '../repository/wallet_repository.dart';

enum CircuitState { closed, open, halfOpen }

class RetryOptions {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffFactor;
  const RetryOptions({this.maxAttempts = 3, this.initialDelay = const Duration(milliseconds: 300), this.backoffFactor = 2.0});
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
      delay = Duration(milliseconds: (delay.inMilliseconds * opts.backoffFactor).round());
    }
  }
}

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  final db = ref.watch(meropeDatabaseProvider);
  return DriftWalletRepository(db);
});

class WalletController extends AsyncNotifier<double> {
  @override
  FutureOr<double> build() async {
    final repo = ref.watch(walletRepositoryProvider);
    return await withRetry(() => repo.getBalance());
  }

  Future<void> refresh() async {
    MeropeHaptics.lightImpact();
    final repo = ref.watch(walletRepositoryProvider);
    final connectivity = ref.read(connectivityProvider);
    if (connectivity != ConnectivityStatus.online) {
      state = AsyncValue.data(state.value ?? 0.0);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => withRetry(() => repo.getBalance()));
    _invalidateTransactions();
  }

  void _invalidateTransactions() {
    ref.invalidate(transactionsProvider);
  }
}

final walletControllerProvider = AsyncNotifierProvider<WalletController, double>(WalletController.new);

final transactionsProvider = FutureProvider<List<MeropeTransaction>>((ref) async {
  final repo = ref.watch(walletRepositoryProvider);
  return await withRetry(() => repo.getTransactions());
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

final circuitBreakerProvider = Provider<CircuitBreaker>((ref) => CircuitBreaker());

final walletWebSocketProvider = StreamProvider.autoDispose<double>((ref) {
  final wsUrl = const String.fromEnvironment('WALLET_WS_URL', defaultValue: 'wss://api.merope.app/ws/wallet');
  final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  final controller = StreamController<double>();
  channel.stream.listen(
    (data) {
      try {
        final json = data is String ? data : data.toString();
        final parsed = double.tryParse(json.split(':').last.trim()) ?? 0.0;
        controller.add(parsed);
      } catch (_) {}
    },
    onError: (e) => controller.addError(e),
    onDone: () => controller.close(),
  );
  ref.onDispose(() {
    channel.sink.close();
    controller.close();
  });
  return controller.stream;
});
