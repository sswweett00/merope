// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MeropeAuthor _$MeropeAuthorFromJson(Map<String, dynamic> json) {
  return _MeropeAuthor.fromJson(json);
}

/// @nodoc
mixin _$MeropeAuthor {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'influence_score')
  double get influenceScore => throw _privateConstructorUsedError;

  /// Serializes this MeropeAuthor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeropeAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeropeAuthorCopyWith<MeropeAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeropeAuthorCopyWith<$Res> {
  factory $MeropeAuthorCopyWith(
          MeropeAuthor value, $Res Function(MeropeAuthor) then) =
      _$MeropeAuthorCopyWithImpl<$Res, MeropeAuthor>;
  @useResult
  $Res call(
      {String id,
      String username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'influence_score') double influenceScore});
}

/// @nodoc
class _$MeropeAuthorCopyWithImpl<$Res, $Val extends MeropeAuthor>
    implements $MeropeAuthorCopyWith<$Res> {
  _$MeropeAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeropeAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? isVerified = null,
    Object? influenceScore = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      influenceScore: null == influenceScore
          ? _value.influenceScore
          : influenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeropeAuthorImplCopyWith<$Res>
    implements $MeropeAuthorCopyWith<$Res> {
  factory _$$MeropeAuthorImplCopyWith(
          _$MeropeAuthorImpl value, $Res Function(_$MeropeAuthorImpl) then) =
      __$$MeropeAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'influence_score') double influenceScore});
}

/// @nodoc
class __$$MeropeAuthorImplCopyWithImpl<$Res>
    extends _$MeropeAuthorCopyWithImpl<$Res, _$MeropeAuthorImpl>
    implements _$$MeropeAuthorImplCopyWith<$Res> {
  __$$MeropeAuthorImplCopyWithImpl(
      _$MeropeAuthorImpl _value, $Res Function(_$MeropeAuthorImpl) _then)
      : super(_value, _then);

  /// Create a copy of MeropeAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? isVerified = null,
    Object? influenceScore = null,
  }) {
    return _then(_$MeropeAuthorImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      influenceScore: null == influenceScore
          ? _value.influenceScore
          : influenceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeropeAuthorImpl implements _MeropeAuthor {
  const _$MeropeAuthorImpl(
      {required this.id,
      required this.username,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'influence_score') this.influenceScore = 0.0});

  factory _$MeropeAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeropeAuthorImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'influence_score')
  final double influenceScore;

  @override
  String toString() {
    return 'MeropeAuthor(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, isVerified: $isVerified, influenceScore: $influenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeropeAuthorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.influenceScore, influenceScore) ||
                other.influenceScore == influenceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, displayName,
      avatarUrl, isVerified, influenceScore);

  /// Create a copy of MeropeAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeropeAuthorImplCopyWith<_$MeropeAuthorImpl> get copyWith =>
      __$$MeropeAuthorImplCopyWithImpl<_$MeropeAuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeropeAuthorImplToJson(
      this,
    );
  }
}

abstract class _MeropeAuthor implements MeropeAuthor {
  const factory _MeropeAuthor(
          {required final String id,
          required final String username,
          @JsonKey(name: 'display_name') final String? displayName,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'is_verified') final bool isVerified,
          @JsonKey(name: 'influence_score') final double influenceScore}) =
      _$MeropeAuthorImpl;

  factory _MeropeAuthor.fromJson(Map<String, dynamic> json) =
      _$MeropeAuthorImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'influence_score')
  double get influenceScore;

  /// Create a copy of MeropeAuthor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeropeAuthorImplCopyWith<_$MeropeAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SignalResonance _$SignalResonanceFromJson(Map<String, dynamic> json) {
  return _SignalResonance.fromJson(json);
}

/// @nodoc
mixin _$SignalResonance {
  String get type =>
      throw _privateConstructorUsedError; // resonance, sync, flash
  int get amplitude => throw _privateConstructorUsedError; // Replaces count
  @JsonKey(name: 'is_resonated')
  bool get isResonated => throw _privateConstructorUsedError;

  /// Serializes this SignalResonance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignalResonance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignalResonanceCopyWith<SignalResonance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignalResonanceCopyWith<$Res> {
  factory $SignalResonanceCopyWith(
          SignalResonance value, $Res Function(SignalResonance) then) =
      _$SignalResonanceCopyWithImpl<$Res, SignalResonance>;
  @useResult
  $Res call(
      {String type,
      int amplitude,
      @JsonKey(name: 'is_resonated') bool isResonated});
}

/// @nodoc
class _$SignalResonanceCopyWithImpl<$Res, $Val extends SignalResonance>
    implements $SignalResonanceCopyWith<$Res> {
  _$SignalResonanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignalResonance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? amplitude = null,
    Object? isResonated = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amplitude: null == amplitude
          ? _value.amplitude
          : amplitude // ignore: cast_nullable_to_non_nullable
              as int,
      isResonated: null == isResonated
          ? _value.isResonated
          : isResonated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignalResonanceImplCopyWith<$Res>
    implements $SignalResonanceCopyWith<$Res> {
  factory _$$SignalResonanceImplCopyWith(_$SignalResonanceImpl value,
          $Res Function(_$SignalResonanceImpl) then) =
      __$$SignalResonanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      int amplitude,
      @JsonKey(name: 'is_resonated') bool isResonated});
}

/// @nodoc
class __$$SignalResonanceImplCopyWithImpl<$Res>
    extends _$SignalResonanceCopyWithImpl<$Res, _$SignalResonanceImpl>
    implements _$$SignalResonanceImplCopyWith<$Res> {
  __$$SignalResonanceImplCopyWithImpl(
      _$SignalResonanceImpl _value, $Res Function(_$SignalResonanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignalResonance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? amplitude = null,
    Object? isResonated = null,
  }) {
    return _then(_$SignalResonanceImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amplitude: null == amplitude
          ? _value.amplitude
          : amplitude // ignore: cast_nullable_to_non_nullable
              as int,
      isResonated: null == isResonated
          ? _value.isResonated
          : isResonated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignalResonanceImpl implements _SignalResonance {
  const _$SignalResonanceImpl(
      {required this.type,
      required this.amplitude,
      @JsonKey(name: 'is_resonated') this.isResonated = false});

  factory _$SignalResonanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignalResonanceImplFromJson(json);

  @override
  final String type;
// resonance, sync, flash
  @override
  final int amplitude;
// Replaces count
  @override
  @JsonKey(name: 'is_resonated')
  final bool isResonated;

  @override
  String toString() {
    return 'SignalResonance(type: $type, amplitude: $amplitude, isResonated: $isResonated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignalResonanceImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amplitude, amplitude) ||
                other.amplitude == amplitude) &&
            (identical(other.isResonated, isResonated) ||
                other.isResonated == isResonated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, amplitude, isResonated);

  /// Create a copy of SignalResonance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignalResonanceImplCopyWith<_$SignalResonanceImpl> get copyWith =>
      __$$SignalResonanceImplCopyWithImpl<_$SignalResonanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignalResonanceImplToJson(
      this,
    );
  }
}

abstract class _SignalResonance implements SignalResonance {
  const factory _SignalResonance(
          {required final String type,
          required final int amplitude,
          @JsonKey(name: 'is_resonated') final bool isResonated}) =
      _$SignalResonanceImpl;

  factory _SignalResonance.fromJson(Map<String, dynamic> json) =
      _$SignalResonanceImpl.fromJson;

  @override
  String get type; // resonance, sync, flash
  @override
  int get amplitude; // Replaces count
  @override
  @JsonKey(name: 'is_resonated')
  bool get isResonated;

  /// Create a copy of SignalResonance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignalResonanceImplCopyWith<_$SignalResonanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SignalMedia _$SignalMediaFromJson(Map<String, dynamic> json) {
  return _SignalMedia.fromJson(json);
}

/// @nodoc
mixin _$SignalMedia {
  String get url => throw _privateConstructorUsedError;
  MediaType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SignalMedia to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignalMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignalMediaCopyWith<SignalMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignalMediaCopyWith<$Res> {
  factory $SignalMediaCopyWith(
          SignalMedia value, $Res Function(SignalMedia) then) =
      _$SignalMediaCopyWithImpl<$Res, SignalMedia>;
  @useResult
  $Res call(
      {String url,
      MediaType type,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      String? metadata});
}

/// @nodoc
class _$SignalMediaCopyWithImpl<$Res, $Val extends SignalMedia>
    implements $SignalMediaCopyWith<$Res> {
  _$SignalMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignalMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? type = null,
    Object? thumbnailUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignalMediaImplCopyWith<$Res>
    implements $SignalMediaCopyWith<$Res> {
  factory _$$SignalMediaImplCopyWith(
          _$SignalMediaImpl value, $Res Function(_$SignalMediaImpl) then) =
      __$$SignalMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      MediaType type,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      String? metadata});
}

/// @nodoc
class __$$SignalMediaImplCopyWithImpl<$Res>
    extends _$SignalMediaCopyWithImpl<$Res, _$SignalMediaImpl>
    implements _$$SignalMediaImplCopyWith<$Res> {
  __$$SignalMediaImplCopyWithImpl(
      _$SignalMediaImpl _value, $Res Function(_$SignalMediaImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignalMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? type = null,
    Object? thumbnailUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$SignalMediaImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignalMediaImpl implements _SignalMedia {
  const _$SignalMediaImpl(
      {required this.url,
      required this.type,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      this.metadata});

  factory _$SignalMediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignalMediaImplFromJson(json);

  @override
  final String url;
  @override
  final MediaType type;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  final String? metadata;

  @override
  String toString() {
    return 'SignalMedia(url: $url, type: $type, thumbnailUrl: $thumbnailUrl, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignalMediaImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, url, type, thumbnailUrl, metadata);

  /// Create a copy of SignalMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignalMediaImplCopyWith<_$SignalMediaImpl> get copyWith =>
      __$$SignalMediaImplCopyWithImpl<_$SignalMediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignalMediaImplToJson(
      this,
    );
  }
}

abstract class _SignalMedia implements SignalMedia {
  const factory _SignalMedia(
      {required final String url,
      required final MediaType type,
      @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
      final String? metadata}) = _$SignalMediaImpl;

  factory _SignalMedia.fromJson(Map<String, dynamic> json) =
      _$SignalMediaImpl.fromJson;

  @override
  String get url;
  @override
  MediaType get type;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  String? get metadata;

  /// Create a copy of SignalMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignalMediaImplCopyWith<_$SignalMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostLayer _$PostLayerFromJson(Map<String, dynamic> json) {
  return _PostLayer.fromJson(json);
}

/// @nodoc
mixin _$PostLayer {
  int get index => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<SignalMedia> get media => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PostLayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostLayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostLayerCopyWith<PostLayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostLayerCopyWith<$Res> {
  factory $PostLayerCopyWith(PostLayer value, $Res Function(PostLayer) then) =
      _$PostLayerCopyWithImpl<$Res, PostLayer>;
  @useResult
  $Res call(
      {int index,
      String title,
      String content,
      List<SignalMedia> media,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PostLayerCopyWithImpl<$Res, $Val extends PostLayer>
    implements $PostLayerCopyWith<$Res> {
  _$PostLayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostLayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? title = null,
    Object? content = null,
    Object? media = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<SignalMedia>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostLayerImplCopyWith<$Res>
    implements $PostLayerCopyWith<$Res> {
  factory _$$PostLayerImplCopyWith(
          _$PostLayerImpl value, $Res Function(_$PostLayerImpl) then) =
      __$$PostLayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int index,
      String title,
      String content,
      List<SignalMedia> media,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PostLayerImplCopyWithImpl<$Res>
    extends _$PostLayerCopyWithImpl<$Res, _$PostLayerImpl>
    implements _$$PostLayerImplCopyWith<$Res> {
  __$$PostLayerImplCopyWithImpl(
      _$PostLayerImpl _value, $Res Function(_$PostLayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostLayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? title = null,
    Object? content = null,
    Object? media = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PostLayerImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<SignalMedia>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostLayerImpl implements _PostLayer {
  const _$PostLayerImpl(
      {required this.index,
      required this.title,
      required this.content,
      final List<SignalMedia> media = const [],
      final Map<String, dynamic>? metadata})
      : _media = media,
        _metadata = metadata;

  factory _$PostLayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostLayerImplFromJson(json);

  @override
  final int index;
  @override
  final String title;
  @override
  final String content;
  final List<SignalMedia> _media;
  @override
  @JsonKey()
  List<SignalMedia> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

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
    return 'PostLayer(index: $index, title: $title, content: $content, media: $media, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostLayerImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      index,
      title,
      content,
      const DeepCollectionEquality().hash(_media),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PostLayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostLayerImplCopyWith<_$PostLayerImpl> get copyWith =>
      __$$PostLayerImplCopyWithImpl<_$PostLayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostLayerImplToJson(
      this,
    );
  }
}

abstract class _PostLayer implements PostLayer {
  const factory _PostLayer(
      {required final int index,
      required final String title,
      required final String content,
      final List<SignalMedia> media,
      final Map<String, dynamic>? metadata}) = _$PostLayerImpl;

  factory _PostLayer.fromJson(Map<String, dynamic> json) =
      _$PostLayerImpl.fromJson;

  @override
  int get index;
  @override
  String get title;
  @override
  String get content;
  @override
  List<SignalMedia> get media;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PostLayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostLayerImplCopyWith<_$PostLayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MeropeAppCard _$MeropeAppCardFromJson(Map<String, dynamic> json) {
  return _MeropeAppCard.fromJson(json);
}

/// @nodoc
mixin _$MeropeAppCard {
  String get id => throw _privateConstructorUsedError;
  AppCardType get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Serializes this MeropeAppCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeropeAppCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeropeAppCardCopyWith<MeropeAppCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeropeAppCardCopyWith<$Res> {
  factory $MeropeAppCardCopyWith(
          MeropeAppCard value, $Res Function(MeropeAppCard) then) =
      _$MeropeAppCardCopyWithImpl<$Res, MeropeAppCard>;
  @useResult
  $Res call({String id, AppCardType type, Map<String, dynamic> data});
}

/// @nodoc
class _$MeropeAppCardCopyWithImpl<$Res, $Val extends MeropeAppCard>
    implements $MeropeAppCardCopyWith<$Res> {
  _$MeropeAppCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeropeAppCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AppCardType,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeropeAppCardImplCopyWith<$Res>
    implements $MeropeAppCardCopyWith<$Res> {
  factory _$$MeropeAppCardImplCopyWith(
          _$MeropeAppCardImpl value, $Res Function(_$MeropeAppCardImpl) then) =
      __$$MeropeAppCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, AppCardType type, Map<String, dynamic> data});
}

/// @nodoc
class __$$MeropeAppCardImplCopyWithImpl<$Res>
    extends _$MeropeAppCardCopyWithImpl<$Res, _$MeropeAppCardImpl>
    implements _$$MeropeAppCardImplCopyWith<$Res> {
  __$$MeropeAppCardImplCopyWithImpl(
      _$MeropeAppCardImpl _value, $Res Function(_$MeropeAppCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of MeropeAppCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_$MeropeAppCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AppCardType,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeropeAppCardImpl implements _MeropeAppCard {
  const _$MeropeAppCardImpl(
      {required this.id,
      required this.type,
      required final Map<String, dynamic> data})
      : _data = data;

  factory _$MeropeAppCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeropeAppCardImplFromJson(json);

  @override
  final String id;
  @override
  final AppCardType type;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'MeropeAppCard(id: $id, type: $type, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeropeAppCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, const DeepCollectionEquality().hash(_data));

  /// Create a copy of MeropeAppCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeropeAppCardImplCopyWith<_$MeropeAppCardImpl> get copyWith =>
      __$$MeropeAppCardImplCopyWithImpl<_$MeropeAppCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeropeAppCardImplToJson(
      this,
    );
  }
}

abstract class _MeropeAppCard implements MeropeAppCard {
  const factory _MeropeAppCard(
      {required final String id,
      required final AppCardType type,
      required final Map<String, dynamic> data}) = _$MeropeAppCardImpl;

  factory _MeropeAppCard.fromJson(Map<String, dynamic> json) =
      _$MeropeAppCardImpl.fromJson;

  @override
  String get id;
  @override
  AppCardType get type;
  @override
  Map<String, dynamic> get data;

  /// Create a copy of MeropeAppCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeropeAppCardImplCopyWith<_$MeropeAppCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MeropeSignal _$MeropeSignalFromJson(Map<String, dynamic> json) {
  return _MeropeSignal.fromJson(json);
}

/// @nodoc
mixin _$MeropeSignal {
  String get id => throw _privateConstructorUsedError;
  MeropeAuthor get author => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<SignalMedia> get media => throw _privateConstructorUsedError;
  List<SignalResonance> get resonances => throw _privateConstructorUsedError;
  List<PostLayer> get layers => throw _privateConstructorUsedError;
  List<MeropeAppCard> get cards => throw _privateConstructorUsedError;
  @JsonKey(name: 'node_count')
  int get nodeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'amplification_count')
  int get amplificationCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  int get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pinned')
  bool get isPinned => throw _privateConstructorUsedError;
  String? get effect => throw _privateConstructorUsedError;
  @JsonKey(name: 'resonance_frequency')
  double get resonanceFrequency => throw _privateConstructorUsedError;
  @JsonKey(name: 'repost_of')
  MeropeSignal? get repostOf => throw _privateConstructorUsedError;
  String? get quote => throw _privateConstructorUsedError; // Apex Mechanics
  @JsonKey(name: 'is_boosted')
  bool get isBoosted => throw _privateConstructorUsedError;
  @JsonKey(name: 'burn_at')
  int? get burnAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'neural_summary')
  String? get neuralSummary => throw _privateConstructorUsedError;

  /// Serializes this MeropeSignal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeropeSignal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeropeSignalCopyWith<MeropeSignal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeropeSignalCopyWith<$Res> {
  factory $MeropeSignalCopyWith(
          MeropeSignal value, $Res Function(MeropeSignal) then) =
      _$MeropeSignalCopyWithImpl<$Res, MeropeSignal>;
  @useResult
  $Res call(
      {String id,
      MeropeAuthor author,
      String content,
      List<SignalMedia> media,
      List<SignalResonance> resonances,
      List<PostLayer> layers,
      List<MeropeAppCard> cards,
      @JsonKey(name: 'node_count') int nodeCount,
      @JsonKey(name: 'amplification_count') int amplificationCount,
      @JsonKey(name: 'created_at') int createdAt,
      @JsonKey(name: 'is_pinned') bool isPinned,
      String? effect,
      @JsonKey(name: 'resonance_frequency') double resonanceFrequency,
      @JsonKey(name: 'repost_of') MeropeSignal? repostOf,
      String? quote,
      @JsonKey(name: 'is_boosted') bool isBoosted,
      @JsonKey(name: 'burn_at') int? burnAt,
      @JsonKey(name: 'neural_summary') String? neuralSummary});

  $MeropeAuthorCopyWith<$Res> get author;
  $MeropeSignalCopyWith<$Res>? get repostOf;
}

/// @nodoc
class _$MeropeSignalCopyWithImpl<$Res, $Val extends MeropeSignal>
    implements $MeropeSignalCopyWith<$Res> {
  _$MeropeSignalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeropeSignal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? content = null,
    Object? media = null,
    Object? resonances = null,
    Object? layers = null,
    Object? cards = null,
    Object? nodeCount = null,
    Object? amplificationCount = null,
    Object? createdAt = null,
    Object? isPinned = null,
    Object? effect = freezed,
    Object? resonanceFrequency = null,
    Object? repostOf = freezed,
    Object? quote = freezed,
    Object? isBoosted = null,
    Object? burnAt = freezed,
    Object? neuralSummary = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as MeropeAuthor,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<SignalMedia>,
      resonances: null == resonances
          ? _value.resonances
          : resonances // ignore: cast_nullable_to_non_nullable
              as List<SignalResonance>,
      layers: null == layers
          ? _value.layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<PostLayer>,
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<MeropeAppCard>,
      nodeCount: null == nodeCount
          ? _value.nodeCount
          : nodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      amplificationCount: null == amplificationCount
          ? _value.amplificationCount
          : amplificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      effect: freezed == effect
          ? _value.effect
          : effect // ignore: cast_nullable_to_non_nullable
              as String?,
      resonanceFrequency: null == resonanceFrequency
          ? _value.resonanceFrequency
          : resonanceFrequency // ignore: cast_nullable_to_non_nullable
              as double,
      repostOf: freezed == repostOf
          ? _value.repostOf
          : repostOf // ignore: cast_nullable_to_non_nullable
              as MeropeSignal?,
      quote: freezed == quote
          ? _value.quote
          : quote // ignore: cast_nullable_to_non_nullable
              as String?,
      isBoosted: null == isBoosted
          ? _value.isBoosted
          : isBoosted // ignore: cast_nullable_to_non_nullable
              as bool,
      burnAt: freezed == burnAt
          ? _value.burnAt
          : burnAt // ignore: cast_nullable_to_non_nullable
              as int?,
      neuralSummary: freezed == neuralSummary
          ? _value.neuralSummary
          : neuralSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of MeropeSignal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MeropeAuthorCopyWith<$Res> get author {
    return $MeropeAuthorCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  /// Create a copy of MeropeSignal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MeropeSignalCopyWith<$Res>? get repostOf {
    if (_value.repostOf == null) {
      return null;
    }

    return $MeropeSignalCopyWith<$Res>(_value.repostOf!, (value) {
      return _then(_value.copyWith(repostOf: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MeropeSignalImplCopyWith<$Res>
    implements $MeropeSignalCopyWith<$Res> {
  factory _$$MeropeSignalImplCopyWith(
          _$MeropeSignalImpl value, $Res Function(_$MeropeSignalImpl) then) =
      __$$MeropeSignalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MeropeAuthor author,
      String content,
      List<SignalMedia> media,
      List<SignalResonance> resonances,
      List<PostLayer> layers,
      List<MeropeAppCard> cards,
      @JsonKey(name: 'node_count') int nodeCount,
      @JsonKey(name: 'amplification_count') int amplificationCount,
      @JsonKey(name: 'created_at') int createdAt,
      @JsonKey(name: 'is_pinned') bool isPinned,
      String? effect,
      @JsonKey(name: 'resonance_frequency') double resonanceFrequency,
      @JsonKey(name: 'repost_of') MeropeSignal? repostOf,
      String? quote,
      @JsonKey(name: 'is_boosted') bool isBoosted,
      @JsonKey(name: 'burn_at') int? burnAt,
      @JsonKey(name: 'neural_summary') String? neuralSummary});

  @override
  $MeropeAuthorCopyWith<$Res> get author;
  @override
  $MeropeSignalCopyWith<$Res>? get repostOf;
}

/// @nodoc
class __$$MeropeSignalImplCopyWithImpl<$Res>
    extends _$MeropeSignalCopyWithImpl<$Res, _$MeropeSignalImpl>
    implements _$$MeropeSignalImplCopyWith<$Res> {
  __$$MeropeSignalImplCopyWithImpl(
      _$MeropeSignalImpl _value, $Res Function(_$MeropeSignalImpl) _then)
      : super(_value, _then);

  /// Create a copy of MeropeSignal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? content = null,
    Object? media = null,
    Object? resonances = null,
    Object? layers = null,
    Object? cards = null,
    Object? nodeCount = null,
    Object? amplificationCount = null,
    Object? createdAt = null,
    Object? isPinned = null,
    Object? effect = freezed,
    Object? resonanceFrequency = null,
    Object? repostOf = freezed,
    Object? quote = freezed,
    Object? isBoosted = null,
    Object? burnAt = freezed,
    Object? neuralSummary = freezed,
  }) {
    return _then(_$MeropeSignalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as MeropeAuthor,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<SignalMedia>,
      resonances: null == resonances
          ? _value._resonances
          : resonances // ignore: cast_nullable_to_non_nullable
              as List<SignalResonance>,
      layers: null == layers
          ? _value._layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<PostLayer>,
      cards: null == cards
          ? _value._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<MeropeAppCard>,
      nodeCount: null == nodeCount
          ? _value.nodeCount
          : nodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      amplificationCount: null == amplificationCount
          ? _value.amplificationCount
          : amplificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      effect: freezed == effect
          ? _value.effect
          : effect // ignore: cast_nullable_to_non_nullable
              as String?,
      resonanceFrequency: null == resonanceFrequency
          ? _value.resonanceFrequency
          : resonanceFrequency // ignore: cast_nullable_to_non_nullable
              as double,
      repostOf: freezed == repostOf
          ? _value.repostOf
          : repostOf // ignore: cast_nullable_to_non_nullable
              as MeropeSignal?,
      quote: freezed == quote
          ? _value.quote
          : quote // ignore: cast_nullable_to_non_nullable
              as String?,
      isBoosted: null == isBoosted
          ? _value.isBoosted
          : isBoosted // ignore: cast_nullable_to_non_nullable
              as bool,
      burnAt: freezed == burnAt
          ? _value.burnAt
          : burnAt // ignore: cast_nullable_to_non_nullable
              as int?,
      neuralSummary: freezed == neuralSummary
          ? _value.neuralSummary
          : neuralSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeropeSignalImpl implements _MeropeSignal {
  const _$MeropeSignalImpl(
      {required this.id,
      required this.author,
      required this.content,
      final List<SignalMedia> media = const [],
      final List<SignalResonance> resonances = const [],
      final List<PostLayer> layers = const [],
      final List<MeropeAppCard> cards = const [],
      @JsonKey(name: 'node_count') this.nodeCount = 0,
      @JsonKey(name: 'amplification_count') this.amplificationCount = 0,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'is_pinned') this.isPinned = false,
      this.effect,
      @JsonKey(name: 'resonance_frequency') this.resonanceFrequency = 0.0,
      @JsonKey(name: 'repost_of') this.repostOf,
      this.quote,
      @JsonKey(name: 'is_boosted') this.isBoosted = false,
      @JsonKey(name: 'burn_at') this.burnAt,
      @JsonKey(name: 'neural_summary') this.neuralSummary})
      : _media = media,
        _resonances = resonances,
        _layers = layers,
        _cards = cards;

  factory _$MeropeSignalImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeropeSignalImplFromJson(json);

  @override
  final String id;
  @override
  final MeropeAuthor author;
  @override
  final String content;
  final List<SignalMedia> _media;
  @override
  @JsonKey()
  List<SignalMedia> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  final List<SignalResonance> _resonances;
  @override
  @JsonKey()
  List<SignalResonance> get resonances {
    if (_resonances is EqualUnmodifiableListView) return _resonances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resonances);
  }

  final List<PostLayer> _layers;
  @override
  @JsonKey()
  List<PostLayer> get layers {
    if (_layers is EqualUnmodifiableListView) return _layers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layers);
  }

  final List<MeropeAppCard> _cards;
  @override
  @JsonKey()
  List<MeropeAppCard> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  @JsonKey(name: 'node_count')
  final int nodeCount;
  @override
  @JsonKey(name: 'amplification_count')
  final int amplificationCount;
  @override
  @JsonKey(name: 'created_at')
  final int createdAt;
  @override
  @JsonKey(name: 'is_pinned')
  final bool isPinned;
  @override
  final String? effect;
  @override
  @JsonKey(name: 'resonance_frequency')
  final double resonanceFrequency;
  @override
  @JsonKey(name: 'repost_of')
  final MeropeSignal? repostOf;
  @override
  final String? quote;
// Apex Mechanics
  @override
  @JsonKey(name: 'is_boosted')
  final bool isBoosted;
  @override
  @JsonKey(name: 'burn_at')
  final int? burnAt;
  @override
  @JsonKey(name: 'neural_summary')
  final String? neuralSummary;

  @override
  String toString() {
    return 'MeropeSignal(id: $id, author: $author, content: $content, media: $media, resonances: $resonances, layers: $layers, cards: $cards, nodeCount: $nodeCount, amplificationCount: $amplificationCount, createdAt: $createdAt, isPinned: $isPinned, effect: $effect, resonanceFrequency: $resonanceFrequency, repostOf: $repostOf, quote: $quote, isBoosted: $isBoosted, burnAt: $burnAt, neuralSummary: $neuralSummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeropeSignalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality()
                .equals(other._resonances, _resonances) &&
            const DeepCollectionEquality().equals(other._layers, _layers) &&
            const DeepCollectionEquality().equals(other._cards, _cards) &&
            (identical(other.nodeCount, nodeCount) ||
                other.nodeCount == nodeCount) &&
            (identical(other.amplificationCount, amplificationCount) ||
                other.amplificationCount == amplificationCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.effect, effect) || other.effect == effect) &&
            (identical(other.resonanceFrequency, resonanceFrequency) ||
                other.resonanceFrequency == resonanceFrequency) &&
            (identical(other.repostOf, repostOf) ||
                other.repostOf == repostOf) &&
            (identical(other.quote, quote) || other.quote == quote) &&
            (identical(other.isBoosted, isBoosted) ||
                other.isBoosted == isBoosted) &&
            (identical(other.burnAt, burnAt) || other.burnAt == burnAt) &&
            (identical(other.neuralSummary, neuralSummary) ||
                other.neuralSummary == neuralSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      author,
      content,
      const DeepCollectionEquality().hash(_media),
      const DeepCollectionEquality().hash(_resonances),
      const DeepCollectionEquality().hash(_layers),
      const DeepCollectionEquality().hash(_cards),
      nodeCount,
      amplificationCount,
      createdAt,
      isPinned,
      effect,
      resonanceFrequency,
      repostOf,
      quote,
      isBoosted,
      burnAt,
      neuralSummary);

  /// Create a copy of MeropeSignal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeropeSignalImplCopyWith<_$MeropeSignalImpl> get copyWith =>
      __$$MeropeSignalImplCopyWithImpl<_$MeropeSignalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeropeSignalImplToJson(
      this,
    );
  }
}

abstract class _MeropeSignal implements MeropeSignal {
  const factory _MeropeSignal(
          {required final String id,
          required final MeropeAuthor author,
          required final String content,
          final List<SignalMedia> media,
          final List<SignalResonance> resonances,
          final List<PostLayer> layers,
          final List<MeropeAppCard> cards,
          @JsonKey(name: 'node_count') final int nodeCount,
          @JsonKey(name: 'amplification_count') final int amplificationCount,
          @JsonKey(name: 'created_at') required final int createdAt,
          @JsonKey(name: 'is_pinned') final bool isPinned,
          final String? effect,
          @JsonKey(name: 'resonance_frequency') final double resonanceFrequency,
          @JsonKey(name: 'repost_of') final MeropeSignal? repostOf,
          final String? quote,
          @JsonKey(name: 'is_boosted') final bool isBoosted,
          @JsonKey(name: 'burn_at') final int? burnAt,
          @JsonKey(name: 'neural_summary') final String? neuralSummary}) =
      _$MeropeSignalImpl;

  factory _MeropeSignal.fromJson(Map<String, dynamic> json) =
      _$MeropeSignalImpl.fromJson;

  @override
  String get id;
  @override
  MeropeAuthor get author;
  @override
  String get content;
  @override
  List<SignalMedia> get media;
  @override
  List<SignalResonance> get resonances;
  @override
  List<PostLayer> get layers;
  @override
  List<MeropeAppCard> get cards;
  @override
  @JsonKey(name: 'node_count')
  int get nodeCount;
  @override
  @JsonKey(name: 'amplification_count')
  int get amplificationCount;
  @override
  @JsonKey(name: 'created_at')
  int get createdAt;
  @override
  @JsonKey(name: 'is_pinned')
  bool get isPinned;
  @override
  String? get effect;
  @override
  @JsonKey(name: 'resonance_frequency')
  double get resonanceFrequency;
  @override
  @JsonKey(name: 'repost_of')
  MeropeSignal? get repostOf;
  @override
  String? get quote; // Apex Mechanics
  @override
  @JsonKey(name: 'is_boosted')
  bool get isBoosted;
  @override
  @JsonKey(name: 'burn_at')
  int? get burnAt;
  @override
  @JsonKey(name: 'neural_summary')
  String? get neuralSummary;

  /// Create a copy of MeropeSignal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeropeSignalImplCopyWith<_$MeropeSignalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
