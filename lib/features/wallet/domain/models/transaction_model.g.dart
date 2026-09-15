// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeropeTransactionImpl _$$MeropeTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$MeropeTransactionImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['transaction_type']),
      createdAt: _dateTimeFromJson(json['created_at']),
      description: json['description'] as String,
      status:
          $enumDecode(_$TransactionStatusEnumMap, json['transaction_status']),
      currency: json['currency'] as String,
      fee: (json['fee'] as num).toDouble(),
      category: json['category'] as String?,
      fromAccountId: json['from_account_id'] as String?,
      toAccountId: json['to_account_id'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      fraudScore: (json['fraud_score'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MeropeTransactionImplToJson(
        _$MeropeTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'transaction_type': _$TransactionTypeEnumMap[instance.type]!,
      'created_at': _dateTimeToJson(instance.createdAt),
      'description': instance.description,
      'transaction_status': _$TransactionStatusEnumMap[instance.status]!,
      'currency': instance.currency,
      'fee': instance.fee,
      'category': instance.category,
      'from_account_id': instance.fromAccountId,
      'to_account_id': instance.toAccountId,
      'receipt_url': instance.receiptUrl,
      'fraud_score': instance.fraudScore,
      'metadata': instance.metadata,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.credit: 'credit',
  TransactionType.debit: 'debit',
  TransactionType.refund: 'refund',
  TransactionType.fee: 'fee',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.completed: 'completed',
  TransactionStatus.failed: 'failed',
  TransactionStatus.reversed: 'reversed',
};
