// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_key_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiKeyUsageStats _$ApiKeyUsageStatsFromJson(Map<String, dynamic> json) {
  return _ApiKeyUsageStats.fromJson(json);
}

/// @nodoc
mixin _$ApiKeyUsageStats {
  @JsonKey(name: 'total_requests')
  int get totalRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'failed_requests')
  int get failedRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_used_ip')
  String get lastUsedIp => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_by_day')
  Map<String, dynamic> get usageByDay => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiKeyUsageStatsCopyWith<ApiKeyUsageStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiKeyUsageStatsCopyWith<$Res> {
  factory $ApiKeyUsageStatsCopyWith(
          ApiKeyUsageStats value, $Res Function(ApiKeyUsageStats) then) =
      _$ApiKeyUsageStatsCopyWithImpl<$Res, ApiKeyUsageStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_requests') int totalRequests,
      @JsonKey(name: 'failed_requests') int failedRequests,
      @JsonKey(name: 'last_used_ip') String lastUsedIp,
      @JsonKey(name: 'usage_by_day') Map<String, dynamic> usageByDay});
}

/// @nodoc
class _$ApiKeyUsageStatsCopyWithImpl<$Res, $Val extends ApiKeyUsageStats>
    implements $ApiKeyUsageStatsCopyWith<$Res> {
  _$ApiKeyUsageStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRequests = null,
    Object? failedRequests = null,
    Object? lastUsedIp = null,
    Object? usageByDay = null,
  }) {
    return _then(_value.copyWith(
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      failedRequests: null == failedRequests
          ? _value.failedRequests
          : failedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      lastUsedIp: null == lastUsedIp
          ? _value.lastUsedIp
          : lastUsedIp // ignore: cast_nullable_to_non_nullable
              as String,
      usageByDay: null == usageByDay
          ? _value.usageByDay
          : usageByDay // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiKeyUsageStatsImplCopyWith<$Res>
    implements $ApiKeyUsageStatsCopyWith<$Res> {
  factory _$$ApiKeyUsageStatsImplCopyWith(_$ApiKeyUsageStatsImpl value,
          $Res Function(_$ApiKeyUsageStatsImpl) then) =
      __$$ApiKeyUsageStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_requests') int totalRequests,
      @JsonKey(name: 'failed_requests') int failedRequests,
      @JsonKey(name: 'last_used_ip') String lastUsedIp,
      @JsonKey(name: 'usage_by_day') Map<String, dynamic> usageByDay});
}

/// @nodoc
class __$$ApiKeyUsageStatsImplCopyWithImpl<$Res>
    extends _$ApiKeyUsageStatsCopyWithImpl<$Res, _$ApiKeyUsageStatsImpl>
    implements _$$ApiKeyUsageStatsImplCopyWith<$Res> {
  __$$ApiKeyUsageStatsImplCopyWithImpl(_$ApiKeyUsageStatsImpl _value,
      $Res Function(_$ApiKeyUsageStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRequests = null,
    Object? failedRequests = null,
    Object? lastUsedIp = null,
    Object? usageByDay = null,
  }) {
    return _then(_$ApiKeyUsageStatsImpl(
      totalRequests: null == totalRequests
          ? _value.totalRequests
          : totalRequests // ignore: cast_nullable_to_non_nullable
              as int,
      failedRequests: null == failedRequests
          ? _value.failedRequests
          : failedRequests // ignore: cast_nullable_to_non_nullable
              as int,
      lastUsedIp: null == lastUsedIp
          ? _value.lastUsedIp
          : lastUsedIp // ignore: cast_nullable_to_non_nullable
              as String,
      usageByDay: null == usageByDay
          ? _value._usageByDay
          : usageByDay // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiKeyUsageStatsImpl implements _ApiKeyUsageStats {
  const _$ApiKeyUsageStatsImpl(
      {@JsonKey(name: 'total_requests') this.totalRequests = 0,
      @JsonKey(name: 'failed_requests') this.failedRequests = 0,
      @JsonKey(name: 'last_used_ip') this.lastUsedIp = '',
      @JsonKey(name: 'usage_by_day')
      final Map<String, dynamic> usageByDay = const {}})
      : _usageByDay = usageByDay;

  factory _$ApiKeyUsageStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiKeyUsageStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_requests')
  final int totalRequests;
  @override
  @JsonKey(name: 'failed_requests')
  final int failedRequests;
  @override
  @JsonKey(name: 'last_used_ip')
  final String lastUsedIp;
  final Map<String, dynamic> _usageByDay;
  @override
  @JsonKey(name: 'usage_by_day')
  Map<String, dynamic> get usageByDay {
    if (_usageByDay is EqualUnmodifiableMapView) return _usageByDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_usageByDay);
  }

  @override
  String toString() {
    return 'ApiKeyUsageStats(totalRequests: $totalRequests, failedRequests: $failedRequests, lastUsedIp: $lastUsedIp, usageByDay: $usageByDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiKeyUsageStatsImpl &&
            (identical(other.totalRequests, totalRequests) ||
                other.totalRequests == totalRequests) &&
            (identical(other.failedRequests, failedRequests) ||
                other.failedRequests == failedRequests) &&
            (identical(other.lastUsedIp, lastUsedIp) ||
                other.lastUsedIp == lastUsedIp) &&
            const DeepCollectionEquality()
                .equals(other._usageByDay, _usageByDay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalRequests, failedRequests,
      lastUsedIp, const DeepCollectionEquality().hash(_usageByDay));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiKeyUsageStatsImplCopyWith<_$ApiKeyUsageStatsImpl> get copyWith =>
      __$$ApiKeyUsageStatsImplCopyWithImpl<_$ApiKeyUsageStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiKeyUsageStatsImplToJson(
      this,
    );
  }
}

abstract class _ApiKeyUsageStats implements ApiKeyUsageStats {
  const factory _ApiKeyUsageStats(
      {@JsonKey(name: 'total_requests') final int totalRequests,
      @JsonKey(name: 'failed_requests') final int failedRequests,
      @JsonKey(name: 'last_used_ip') final String lastUsedIp,
      @JsonKey(name: 'usage_by_day')
      final Map<String, dynamic> usageByDay}) = _$ApiKeyUsageStatsImpl;

  factory _ApiKeyUsageStats.fromJson(Map<String, dynamic> json) =
      _$ApiKeyUsageStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_requests')
  int get totalRequests;
  @override
  @JsonKey(name: 'failed_requests')
  int get failedRequests;
  @override
  @JsonKey(name: 'last_used_ip')
  String get lastUsedIp;
  @override
  @JsonKey(name: 'usage_by_day')
  Map<String, dynamic> get usageByDay;
  @override
  @JsonKey(ignore: true)
  _$$ApiKeyUsageStatsImplCopyWith<_$ApiKeyUsageStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) {
  return _ApiKey.fromJson(json);
}

/// @nodoc
mixin _$ApiKey {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError;
  @JsonKey(name: 'key_hash')
  String? get keyHash => throw _privateConstructorUsedError;
  @JsonKey(name: 'key_prefix')
  String get keyPrefix => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get scopes => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate_limit_rpm')
  int get rateLimitRpm => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate_limit_rph')
  int get rateLimitRph => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_used_at')
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_whitelist')
  List<String> get ipWhitelist => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_stats')
  ApiKeyUsageStats? get usageStats => throw _privateConstructorUsedError;
  @JsonKey(name: 'raw_key')
  String? get rawKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiKeyCopyWith<ApiKey> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiKeyCopyWith<$Res> {
  factory $ApiKeyCopyWith(ApiKey value, $Res Function(ApiKey) then) =
      _$ApiKeyCopyWithImpl<$Res, ApiKey>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'key_hash') String? keyHash,
      @JsonKey(name: 'key_prefix') String keyPrefix,
      String name,
      String? description,
      List<String> scopes,
      @JsonKey(name: 'rate_limit_rpm') int rateLimitRpm,
      @JsonKey(name: 'rate_limit_rph') int rateLimitRph,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_used_at') DateTime? lastUsedAt,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'ip_whitelist') List<String> ipWhitelist,
      @JsonKey(name: 'usage_stats') ApiKeyUsageStats? usageStats,
      @JsonKey(name: 'raw_key') String? rawKey});

  $ApiKeyUsageStatsCopyWith<$Res>? get usageStats;
}

/// @nodoc
class _$ApiKeyCopyWithImpl<$Res, $Val extends ApiKey>
    implements $ApiKeyCopyWith<$Res> {
  _$ApiKeyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appId = null,
    Object? keyHash = freezed,
    Object? keyPrefix = null,
    Object? name = null,
    Object? description = freezed,
    Object? scopes = null,
    Object? rateLimitRpm = null,
    Object? rateLimitRph = null,
    Object? isActive = null,
    Object? lastUsedAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? ipWhitelist = null,
    Object? usageStats = freezed,
    Object? rawKey = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      keyHash: freezed == keyHash
          ? _value.keyHash
          : keyHash // ignore: cast_nullable_to_non_nullable
              as String?,
      keyPrefix: null == keyPrefix
          ? _value.keyPrefix
          : keyPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      scopes: null == scopes
          ? _value.scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rateLimitRpm: null == rateLimitRpm
          ? _value.rateLimitRpm
          : rateLimitRpm // ignore: cast_nullable_to_non_nullable
              as int,
      rateLimitRph: null == rateLimitRph
          ? _value.rateLimitRph
          : rateLimitRph // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ipWhitelist: null == ipWhitelist
          ? _value.ipWhitelist
          : ipWhitelist // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usageStats: freezed == usageStats
          ? _value.usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as ApiKeyUsageStats?,
      rawKey: freezed == rawKey
          ? _value.rawKey
          : rawKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiKeyUsageStatsCopyWith<$Res>? get usageStats {
    if (_value.usageStats == null) {
      return null;
    }

    return $ApiKeyUsageStatsCopyWith<$Res>(_value.usageStats!, (value) {
      return _then(_value.copyWith(usageStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiKeyImplCopyWith<$Res> implements $ApiKeyCopyWith<$Res> {
  factory _$$ApiKeyImplCopyWith(
          _$ApiKeyImpl value, $Res Function(_$ApiKeyImpl) then) =
      __$$ApiKeyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'key_hash') String? keyHash,
      @JsonKey(name: 'key_prefix') String keyPrefix,
      String name,
      String? description,
      List<String> scopes,
      @JsonKey(name: 'rate_limit_rpm') int rateLimitRpm,
      @JsonKey(name: 'rate_limit_rph') int rateLimitRph,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_used_at') DateTime? lastUsedAt,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'ip_whitelist') List<String> ipWhitelist,
      @JsonKey(name: 'usage_stats') ApiKeyUsageStats? usageStats,
      @JsonKey(name: 'raw_key') String? rawKey});

  @override
  $ApiKeyUsageStatsCopyWith<$Res>? get usageStats;
}

/// @nodoc
class __$$ApiKeyImplCopyWithImpl<$Res>
    extends _$ApiKeyCopyWithImpl<$Res, _$ApiKeyImpl>
    implements _$$ApiKeyImplCopyWith<$Res> {
  __$$ApiKeyImplCopyWithImpl(
      _$ApiKeyImpl _value, $Res Function(_$ApiKeyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appId = null,
    Object? keyHash = freezed,
    Object? keyPrefix = null,
    Object? name = null,
    Object? description = freezed,
    Object? scopes = null,
    Object? rateLimitRpm = null,
    Object? rateLimitRph = null,
    Object? isActive = null,
    Object? lastUsedAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? ipWhitelist = null,
    Object? usageStats = freezed,
    Object? rawKey = freezed,
  }) {
    return _then(_$ApiKeyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      keyHash: freezed == keyHash
          ? _value.keyHash
          : keyHash // ignore: cast_nullable_to_non_nullable
              as String?,
      keyPrefix: null == keyPrefix
          ? _value.keyPrefix
          : keyPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      scopes: null == scopes
          ? _value._scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rateLimitRpm: null == rateLimitRpm
          ? _value.rateLimitRpm
          : rateLimitRpm // ignore: cast_nullable_to_non_nullable
              as int,
      rateLimitRph: null == rateLimitRph
          ? _value.rateLimitRph
          : rateLimitRph // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ipWhitelist: null == ipWhitelist
          ? _value._ipWhitelist
          : ipWhitelist // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usageStats: freezed == usageStats
          ? _value.usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as ApiKeyUsageStats?,
      rawKey: freezed == rawKey
          ? _value.rawKey
          : rawKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiKeyImpl extends _ApiKey {
  const _$ApiKeyImpl(
      {required this.id,
      @JsonKey(name: 'app_id') required this.appId,
      @JsonKey(name: 'key_hash') this.keyHash,
      @JsonKey(name: 'key_prefix') required this.keyPrefix,
      required this.name,
      this.description,
      final List<String> scopes = const [],
      @JsonKey(name: 'rate_limit_rpm') this.rateLimitRpm = 100,
      @JsonKey(name: 'rate_limit_rph') this.rateLimitRph = 1000,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'last_used_at') this.lastUsedAt,
      @JsonKey(name: 'expires_at') this.expiresAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'ip_whitelist') final List<String> ipWhitelist = const [],
      @JsonKey(name: 'usage_stats') this.usageStats,
      @JsonKey(name: 'raw_key') this.rawKey})
      : _scopes = scopes,
        _ipWhitelist = ipWhitelist,
        super._();

  factory _$ApiKeyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiKeyImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'app_id')
  final String appId;
  @override
  @JsonKey(name: 'key_hash')
  final String? keyHash;
  @override
  @JsonKey(name: 'key_prefix')
  final String keyPrefix;
  @override
  final String name;
  @override
  final String? description;
  final List<String> _scopes;
  @override
  @JsonKey()
  List<String> get scopes {
    if (_scopes is EqualUnmodifiableListView) return _scopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scopes);
  }

  @override
  @JsonKey(name: 'rate_limit_rpm')
  final int rateLimitRpm;
  @override
  @JsonKey(name: 'rate_limit_rph')
  final int rateLimitRph;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'last_used_at')
  final DateTime? lastUsedAt;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<String> _ipWhitelist;
  @override
  @JsonKey(name: 'ip_whitelist')
  List<String> get ipWhitelist {
    if (_ipWhitelist is EqualUnmodifiableListView) return _ipWhitelist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ipWhitelist);
  }

  @override
  @JsonKey(name: 'usage_stats')
  final ApiKeyUsageStats? usageStats;
  @override
  @JsonKey(name: 'raw_key')
  final String? rawKey;

  @override
  String toString() {
    return 'ApiKey(id: $id, appId: $appId, keyHash: $keyHash, keyPrefix: $keyPrefix, name: $name, description: $description, scopes: $scopes, rateLimitRpm: $rateLimitRpm, rateLimitRph: $rateLimitRph, isActive: $isActive, lastUsedAt: $lastUsedAt, expiresAt: $expiresAt, createdAt: $createdAt, ipWhitelist: $ipWhitelist, usageStats: $usageStats, rawKey: $rawKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiKeyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.keyHash, keyHash) || other.keyHash == keyHash) &&
            (identical(other.keyPrefix, keyPrefix) ||
                other.keyPrefix == keyPrefix) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._scopes, _scopes) &&
            (identical(other.rateLimitRpm, rateLimitRpm) ||
                other.rateLimitRpm == rateLimitRpm) &&
            (identical(other.rateLimitRph, rateLimitRph) ||
                other.rateLimitRph == rateLimitRph) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._ipWhitelist, _ipWhitelist) &&
            (identical(other.usageStats, usageStats) ||
                other.usageStats == usageStats) &&
            (identical(other.rawKey, rawKey) || other.rawKey == rawKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      appId,
      keyHash,
      keyPrefix,
      name,
      description,
      const DeepCollectionEquality().hash(_scopes),
      rateLimitRpm,
      rateLimitRph,
      isActive,
      lastUsedAt,
      expiresAt,
      createdAt,
      const DeepCollectionEquality().hash(_ipWhitelist),
      usageStats,
      rawKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiKeyImplCopyWith<_$ApiKeyImpl> get copyWith =>
      __$$ApiKeyImplCopyWithImpl<_$ApiKeyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiKeyImplToJson(
      this,
    );
  }
}

abstract class _ApiKey extends ApiKey {
  const factory _ApiKey(
      {required final String id,
      @JsonKey(name: 'app_id') required final String appId,
      @JsonKey(name: 'key_hash') final String? keyHash,
      @JsonKey(name: 'key_prefix') required final String keyPrefix,
      required final String name,
      final String? description,
      final List<String> scopes,
      @JsonKey(name: 'rate_limit_rpm') final int rateLimitRpm,
      @JsonKey(name: 'rate_limit_rph') final int rateLimitRph,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'last_used_at') final DateTime? lastUsedAt,
      @JsonKey(name: 'expires_at') final DateTime? expiresAt,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'ip_whitelist') final List<String> ipWhitelist,
      @JsonKey(name: 'usage_stats') final ApiKeyUsageStats? usageStats,
      @JsonKey(name: 'raw_key') final String? rawKey}) = _$ApiKeyImpl;
  const _ApiKey._() : super._();

  factory _ApiKey.fromJson(Map<String, dynamic> json) = _$ApiKeyImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'app_id')
  String get appId;
  @override
  @JsonKey(name: 'key_hash')
  String? get keyHash;
  @override
  @JsonKey(name: 'key_prefix')
  String get keyPrefix;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<String> get scopes;
  @override
  @JsonKey(name: 'rate_limit_rpm')
  int get rateLimitRpm;
  @override
  @JsonKey(name: 'rate_limit_rph')
  int get rateLimitRph;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'last_used_at')
  DateTime? get lastUsedAt;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'ip_whitelist')
  List<String> get ipWhitelist;
  @override
  @JsonKey(name: 'usage_stats')
  ApiKeyUsageStats? get usageStats;
  @override
  @JsonKey(name: 'raw_key')
  String? get rawKey;
  @override
  @JsonKey(ignore: true)
  _$$ApiKeyImplCopyWith<_$ApiKeyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
