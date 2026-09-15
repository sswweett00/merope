// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MeropeTransaction _$MeropeTransactionFromJson(Map<String, dynamic> json) {
  return _MeropeTransaction.fromJson(json);
}

/// @nodoc
mixin _$MeropeTransaction {
  String get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_type')
  TransactionType get type => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_status')
  TransactionStatus get status => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  double get fee => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_account_id')
  String? get fromAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_account_id')
  String? get toAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'fraud_score')
  double? get fraudScore => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeropeTransactionCopyWith<MeropeTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeropeTransactionCopyWith<$Res> {
  factory $MeropeTransactionCopyWith(
          MeropeTransaction value, $Res Function(MeropeTransaction) then) =
      _$MeropeTransactionCopyWithImpl<$Res, MeropeTransaction>;
  @useResult
  $Res call(
      {String id,
      double amount,
      @JsonKey(name: 'transaction_type') TransactionType type,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      DateTime createdAt,
      String description,
      @JsonKey(name: 'transaction_status') TransactionStatus status,
      String currency,
      double fee,
      String? category,
      @JsonKey(name: 'from_account_id') String? fromAccountId,
      @JsonKey(name: 'to_account_id') String? toAccountId,
      @JsonKey(name: 'receipt_url') String? receiptUrl,
      @JsonKey(name: 'fraud_score') double? fraudScore,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$MeropeTransactionCopyWithImpl<$Res, $Val extends MeropeTransaction>
    implements $MeropeTransactionCopyWith<$Res> {
  _$MeropeTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? type = null,
    Object? createdAt = null,
    Object? description = null,
    Object? status = null,
    Object? currency = null,
    Object? fee = null,
    Object? category = freezed,
    Object? fromAccountId = freezed,
    Object? toAccountId = freezed,
    Object? receiptUrl = freezed,
    Object? fraudScore = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      fromAccountId: freezed == fromAccountId
          ? _value.fromAccountId
          : fromAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      toAccountId: freezed == toAccountId
          ? _value.toAccountId
          : toAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fraudScore: freezed == fraudScore
          ? _value.fraudScore
          : fraudScore // ignore: cast_nullable_to_non_nullable
              as double?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeropeTransactionImplCopyWith<$Res>
    implements $MeropeTransactionCopyWith<$Res> {
  factory _$$MeropeTransactionImplCopyWith(_$MeropeTransactionImpl value,
          $Res Function(_$MeropeTransactionImpl) then) =
      __$$MeropeTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double amount,
      @JsonKey(name: 'transaction_type') TransactionType type,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      DateTime createdAt,
      String description,
      @JsonKey(name: 'transaction_status') TransactionStatus status,
      String currency,
      double fee,
      String? category,
      @JsonKey(name: 'from_account_id') String? fromAccountId,
      @JsonKey(name: 'to_account_id') String? toAccountId,
      @JsonKey(name: 'receipt_url') String? receiptUrl,
      @JsonKey(name: 'fraud_score') double? fraudScore,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$MeropeTransactionImplCopyWithImpl<$Res>
    extends _$MeropeTransactionCopyWithImpl<$Res, _$MeropeTransactionImpl>
    implements _$$MeropeTransactionImplCopyWith<$Res> {
  __$$MeropeTransactionImplCopyWithImpl(_$MeropeTransactionImpl _value,
      $Res Function(_$MeropeTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? type = null,
    Object? createdAt = null,
    Object? description = null,
    Object? status = null,
    Object? currency = null,
    Object? fee = null,
    Object? category = freezed,
    Object? fromAccountId = freezed,
    Object? toAccountId = freezed,
    Object? receiptUrl = freezed,
    Object? fraudScore = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$MeropeTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      fromAccountId: freezed == fromAccountId
          ? _value.fromAccountId
          : fromAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      toAccountId: freezed == toAccountId
          ? _value.toAccountId
          : toAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fraudScore: freezed == fraudScore
          ? _value.fraudScore
          : fraudScore // ignore: cast_nullable_to_non_nullable
              as double?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeropeTransactionImpl implements _MeropeTransaction {
  const _$MeropeTransactionImpl(
      {required this.id,
      required this.amount,
      @JsonKey(name: 'transaction_type') required this.type,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      required this.createdAt,
      required this.description,
      @JsonKey(name: 'transaction_status') required this.status,
      required this.currency,
      required this.fee,
      this.category,
      @JsonKey(name: 'from_account_id') this.fromAccountId,
      @JsonKey(name: 'to_account_id') this.toAccountId,
      @JsonKey(name: 'receipt_url') this.receiptUrl,
      @JsonKey(name: 'fraud_score') this.fraudScore,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$MeropeTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeropeTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final double amount;
  @override
  @JsonKey(name: 'transaction_type')
  final TransactionType type;
  @override
  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @override
  final String description;
  @override
  @JsonKey(name: 'transaction_status')
  final TransactionStatus status;
  @override
  final String currency;
  @override
  final double fee;
  @override
  final String? category;
  @override
  @JsonKey(name: 'from_account_id')
  final String? fromAccountId;
  @override
  @JsonKey(name: 'to_account_id')
  final String? toAccountId;
  @override
  @JsonKey(name: 'receipt_url')
  final String? receiptUrl;
  @override
  @JsonKey(name: 'fraud_score')
  final double? fraudScore;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MeropeTransaction(id: $id, amount: $amount, type: $type, createdAt: $createdAt, description: $description, status: $status, currency: $currency, fee: $fee, category: $category, fromAccountId: $fromAccountId, toAccountId: $toAccountId, receiptUrl: $receiptUrl, fraudScore: $fraudScore, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeropeTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.fromAccountId, fromAccountId) ||
                other.fromAccountId == fromAccountId) &&
            (identical(other.toAccountId, toAccountId) ||
                other.toAccountId == toAccountId) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl) &&
            (identical(other.fraudScore, fraudScore) ||
                other.fraudScore == fraudScore) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      amount,
      type,
      createdAt,
      description,
      status,
      currency,
      fee,
      category,
      fromAccountId,
      toAccountId,
      receiptUrl,
      fraudScore,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MeropeTransactionImplCopyWith<_$MeropeTransactionImpl> get copyWith =>
      __$$MeropeTransactionImplCopyWithImpl<_$MeropeTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeropeTransactionImplToJson(
      this,
    );
  }
}

abstract class _MeropeTransaction implements MeropeTransaction {
  const factory _MeropeTransaction(
      {required final String id,
      required final double amount,
      @JsonKey(name: 'transaction_type') required final TransactionType type,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      required final DateTime createdAt,
      required final String description,
      @JsonKey(name: 'transaction_status')
      required final TransactionStatus status,
      required final String currency,
      required final double fee,
      final String? category,
      @JsonKey(name: 'from_account_id') final String? fromAccountId,
      @JsonKey(name: 'to_account_id') final String? toAccountId,
      @JsonKey(name: 'receipt_url') final String? receiptUrl,
      @JsonKey(name: 'fraud_score') final double? fraudScore,
      final Map<String, dynamic>? metadata}) = _$MeropeTransactionImpl;

  factory _MeropeTransaction.fromJson(Map<String, dynamic> json) =
      _$MeropeTransactionImpl.fromJson;

  @override
  String get id;
  @override
  double get amount;
  @override
  @JsonKey(name: 'transaction_type')
  TransactionType get type;
  @override
  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get createdAt;
  @override
  String get description;
  @override
  @JsonKey(name: 'transaction_status')
  TransactionStatus get status;
  @override
  String get currency;
  @override
  double get fee;
  @override
  String? get category;
  @override
  @JsonKey(name: 'from_account_id')
  String? get fromAccountId;
  @override
  @JsonKey(name: 'to_account_id')
  String? get toAccountId;
  @override
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl;
  @override
  @JsonKey(name: 'fraud_score')
  double? get fraudScore;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$MeropeTransactionImplCopyWith<_$MeropeTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
