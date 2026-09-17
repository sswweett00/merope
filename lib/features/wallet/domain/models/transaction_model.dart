import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType { credit, debit, refund, fee }

enum TransactionStatus { pending, completed, failed, reversed }

@freezed
class MeropeTransaction with _$MeropeTransaction {
  const factory MeropeTransaction({
    required String id,
    required double amount,
    @JsonKey(name: 'transaction_type') required TransactionType type,
    @JsonKey(
        name: 'created_at',
        fromJson: _dateTimeFromJson,
        toJson: _dateTimeToJson)
    required DateTime createdAt,
    required String description,
    @JsonKey(name: 'transaction_status') required TransactionStatus status,
    required String currency,
    required double fee,
    String? category,
    @JsonKey(name: 'from_account_id') String? fromAccountId,
    @JsonKey(name: 'to_account_id') String? toAccountId,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'fraud_score') double? fraudScore,
    Map<String, dynamic>? metadata,
  }) = _MeropeTransaction;

  factory MeropeTransaction.fromJson(Map<String, dynamic> json) =>
      _$MeropeTransactionFromJson(json);
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}

dynamic _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
