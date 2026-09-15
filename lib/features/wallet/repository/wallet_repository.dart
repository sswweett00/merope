import 'package:drift/drift.dart';
import 'package:merope_core/data/database/merope_database.dart' as db;
import '../domain/models/transaction_model.dart';

abstract class IWalletRepository {
  Future<double> getBalance({String? currency});
  Future<List<MeropeTransaction>> getTransactions({
    int limit = 20,
    String? cursor,
    TransactionType? type,
    TransactionStatus? status,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  });
  Future<List<MeropeTransaction>> searchTransactions(String query);
  Future<Map<String, double>> getBalanceByCurrency();
  Future<double> computeFraudScore(MeropeTransaction tx);
}

class DriftWalletRepository implements IWalletRepository {
  final db.MeropeDatabase _db;
  final Map<String, double> _fxRates;
  final Map<String, double> _balanceCache = {};
  DateTime? _balanceCacheTime;

  static const _defaultBaseCurrency = 'MRO';
  static const Duration _cacheTtl = Duration(minutes: 2);

  DriftWalletRepository(this._db, {Map<String, double>? fxRates})
      : _fxRates = fxRates ?? const {'MRO': 1.0, 'USD': 0.035, 'EUR': 0.032, 'TRY': 1.15};

  @override
  Future<double> getBalance({String? currency}) async {
    final target = currency ?? _defaultBaseCurrency;
    final now = DateTime.now();
    if (_balanceCacheTime != null && now.difference(_balanceCacheTime!) < _cacheTtl) {
      return _balanceCache[target] ?? 0.0;
    }

    final rows = await _db.select(_db.transactions).get();
    double sum = 0.0;
    for (final row in rows) {
      final amount = row.amount + (row.fee ?? 0.0);
      final converted = _convert(amount, row.currency, target);
      sum += row.toAccountId == 'me' ? converted : -converted;
    }
    _balanceCache[target] = sum;
    _balanceCacheTime = now;
    return sum;
  }

  @override
  Future<List<MeropeTransaction>> getTransactions({
    int limit = 20,
    String? cursor,
    TransactionType? type,
    TransactionStatus? status,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    final query = _db.select(_db.transactions);

    if (cursor != null && cursor.isNotEmpty) {
      final cursorDate = DateTime.tryParse(cursor);
      if (cursorDate != null) {
        query.where((t) => t.createdAt.isSmallerThanValue(cursorDate));
      }
    }

    if (currency != null) {
      query.where((t) => t.currency.equals(currency));
    }

    if (startDate != null) {
      query.where((t) => t.createdAt.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((t) => t.createdAt.isSmallerOrEqualValue(endDate));
    }

    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    final rows = await query.get();

    List<db.Transaction> filtered = rows;
    if (type != null) {
      filtered = filtered.where((r) => _typeFromRow(r) == type).toList();
    }
    if (status != null) {
      filtered = filtered.where((r) => _statusFromRow(r) == status).toList();
    }

    return filtered.take(limit).map((row) => _mapRow(row)).toList();
  }

  @override
  Future<List<MeropeTransaction>> searchTransactions(String query) async {
    final rows = await _db.select(_db.transactions).get();
    final lower = query.toLowerCase();
    return rows.where((r) {
      final desc = '${r.fromAccountId} to ${r.toAccountId} (${r.currency}) ${r.category ?? ''} ${r.receiptUrl ?? ''}';
      return desc.toLowerCase().contains(lower);
    }).map((row) => _mapRow(row)).toList();
  }

  @override
  Future<Map<String, double>> getBalanceByCurrency() async {
    final rows = await _db.select(_db.transactions).get();
    final Map<String, double> balances = {};
    for (final row in rows) {
      final amount = row.amount + (row.fee ?? 0.0);
      final converted = _convert(amount, row.currency, _defaultBaseCurrency);
      final key = row.currency;
      balances[key] = ((balances[key] ?? 0.0) + (row.toAccountId == 'me' ? converted : -converted));
    }
    return balances;
  }

  @override
  Future<double> computeFraudScore(MeropeTransaction tx) async {
    double score = 0.0;
    if (tx.amount > 10000) score += 0.4;
    if (tx.fraudScore != null && tx.fraudScore! > 0.7) score += 0.3;
    if (tx.metadata != null && tx.metadata!.containsKey('ip_risk')) score += 0.2;
    if (tx.category == 'high_risk') score += 0.1;
    return score.clamp(0.0, 1.0);
  }

  MeropeTransaction _mapRow(db.Transaction row) {
    final isCredit = row.toAccountId == 'me';
    return MeropeTransaction(
      id: row.id,
      amount: row.amount,
      type: isCredit ? TransactionType.credit : TransactionType.debit,
      createdAt: row.createdAt,
      description: '${row.fromAccountId} to ${row.toAccountId} (${row.currency})',
      status: _statusFromRow(row),
      currency: row.currency,
      fee: row.fee ?? 0.0,
      category: row.category,
      fromAccountId: row.fromAccountId,
      toAccountId: row.toAccountId,
      receiptUrl: row.receiptUrl,
      fraudScore: row.fraudScore,
      metadata: row.metadata != null ? {'raw': row.metadata} : null,
    );
  }

  TransactionType _typeFromRow(db.Transaction row) {
    if (row.toAccountId == 'me') return TransactionType.credit;
    return TransactionType.debit;
  }

  TransactionStatus _statusFromRow(db.Transaction row) {
    switch (row.status.toLowerCase()) {
      case 'pending': return TransactionStatus.pending;
      case 'completed': return TransactionStatus.completed;
      case 'failed': return TransactionStatus.failed;
      case 'reversed': return TransactionStatus.reversed;
      default: return TransactionStatus.completed;
    }
  }

  double _convert(double amount, String from, String to) {
    if (from == to) return amount;
    final fromRate = _fxRates[from] ?? 1.0;
    final toRate = _fxRates[to] ?? 1.0;
    return amount / fromRate * toRate;
  }
}
