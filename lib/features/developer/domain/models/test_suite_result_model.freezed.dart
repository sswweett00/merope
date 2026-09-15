// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_suite_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TestResult _$TestResultFromJson(Map<String, dynamic> json) {
  return _TestResult.fromJson(json);
}

/// @nodoc
mixin _$TestResult {
  @JsonKey(name: 'test_name')
  String get testName => throw _privateConstructorUsedError;
  TestStatus get status => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  @JsonKey(name: 'response')
  Map<String, dynamic>? get response => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TestResultCopyWith<TestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestResultCopyWith<$Res> {
  factory $TestResultCopyWith(
          TestResult value, $Res Function(TestResult) then) =
      _$TestResultCopyWithImpl<$Res, TestResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'test_name') String testName,
      TestStatus status,
      Duration duration,
      String? error,
      @JsonKey(name: 'response') Map<String, dynamic>? response});
}

/// @nodoc
class _$TestResultCopyWithImpl<$Res, $Val extends TestResult>
    implements $TestResultCopyWith<$Res> {
  _$TestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testName = null,
    Object? status = null,
    Object? duration = null,
    Object? error = freezed,
    Object? response = freezed,
  }) {
    return _then(_value.copyWith(
      testName: null == testName
          ? _value.testName
          : testName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TestStatus,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestResultImplCopyWith<$Res>
    implements $TestResultCopyWith<$Res> {
  factory _$$TestResultImplCopyWith(
          _$TestResultImpl value, $Res Function(_$TestResultImpl) then) =
      __$$TestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'test_name') String testName,
      TestStatus status,
      Duration duration,
      String? error,
      @JsonKey(name: 'response') Map<String, dynamic>? response});
}

/// @nodoc
class __$$TestResultImplCopyWithImpl<$Res>
    extends _$TestResultCopyWithImpl<$Res, _$TestResultImpl>
    implements _$$TestResultImplCopyWith<$Res> {
  __$$TestResultImplCopyWithImpl(
      _$TestResultImpl _value, $Res Function(_$TestResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testName = null,
    Object? status = null,
    Object? duration = null,
    Object? error = freezed,
    Object? response = freezed,
  }) {
    return _then(_$TestResultImpl(
      testName: null == testName
          ? _value.testName
          : testName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TestStatus,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value._response
          : response // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestResultImpl implements _TestResult {
  const _$TestResultImpl(
      {@JsonKey(name: 'test_name') required this.testName,
      required this.status,
      required this.duration,
      this.error,
      @JsonKey(name: 'response') final Map<String, dynamic>? response})
      : _response = response;

  factory _$TestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestResultImplFromJson(json);

  @override
  @JsonKey(name: 'test_name')
  final String testName;
  @override
  final TestStatus status;
  @override
  final Duration duration;
  @override
  final String? error;
  final Map<String, dynamic>? _response;
  @override
  @JsonKey(name: 'response')
  Map<String, dynamic>? get response {
    final value = _response;
    if (value == null) return null;
    if (_response is EqualUnmodifiableMapView) return _response;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TestResult(testName: $testName, status: $status, duration: $duration, error: $error, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestResultImpl &&
            (identical(other.testName, testName) ||
                other.testName == testName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other._response, _response));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, testName, status, duration,
      error, const DeepCollectionEquality().hash(_response));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestResultImplCopyWith<_$TestResultImpl> get copyWith =>
      __$$TestResultImplCopyWithImpl<_$TestResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestResultImplToJson(
      this,
    );
  }
}

abstract class _TestResult implements TestResult {
  const factory _TestResult(
          {@JsonKey(name: 'test_name') required final String testName,
          required final TestStatus status,
          required final Duration duration,
          final String? error,
          @JsonKey(name: 'response') final Map<String, dynamic>? response}) =
      _$TestResultImpl;

  factory _TestResult.fromJson(Map<String, dynamic> json) =
      _$TestResultImpl.fromJson;

  @override
  @JsonKey(name: 'test_name')
  String get testName;
  @override
  TestStatus get status;
  @override
  Duration get duration;
  @override
  String? get error;
  @override
  @JsonKey(name: 'response')
  Map<String, dynamic>? get response;
  @override
  @JsonKey(ignore: true)
  _$$TestResultImplCopyWith<_$TestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TestSuiteResult _$TestSuiteResultFromJson(Map<String, dynamic> json) {
  return _TestSuiteResult.fromJson(json);
}

/// @nodoc
mixin _$TestSuiteResult {
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_tests')
  int get totalTests => throw _privateConstructorUsedError;
  @JsonKey(name: 'passed_tests')
  int get passedTests => throw _privateConstructorUsedError;
  @JsonKey(name: 'failed_tests')
  int get failedTests => throw _privateConstructorUsedError;
  @JsonKey(name: 'skipped_tests')
  int get skippedTests => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  List<TestResult> get results => throw _privateConstructorUsedError;
  @JsonKey(name: 'executed_at')
  DateTime get executedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TestSuiteResultCopyWith<TestSuiteResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestSuiteResultCopyWith<$Res> {
  factory $TestSuiteResultCopyWith(
          TestSuiteResult value, $Res Function(TestSuiteResult) then) =
      _$TestSuiteResultCopyWithImpl<$Res, TestSuiteResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'total_tests') int totalTests,
      @JsonKey(name: 'passed_tests') int passedTests,
      @JsonKey(name: 'failed_tests') int failedTests,
      @JsonKey(name: 'skipped_tests') int skippedTests,
      Duration duration,
      List<TestResult> results,
      @JsonKey(name: 'executed_at') DateTime executedAt});
}

/// @nodoc
class _$TestSuiteResultCopyWithImpl<$Res, $Val extends TestSuiteResult>
    implements $TestSuiteResultCopyWith<$Res> {
  _$TestSuiteResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? totalTests = null,
    Object? passedTests = null,
    Object? failedTests = null,
    Object? skippedTests = null,
    Object? duration = null,
    Object? results = null,
    Object? executedAt = null,
  }) {
    return _then(_value.copyWith(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      totalTests: null == totalTests
          ? _value.totalTests
          : totalTests // ignore: cast_nullable_to_non_nullable
              as int,
      passedTests: null == passedTests
          ? _value.passedTests
          : passedTests // ignore: cast_nullable_to_non_nullable
              as int,
      failedTests: null == failedTests
          ? _value.failedTests
          : failedTests // ignore: cast_nullable_to_non_nullable
              as int,
      skippedTests: null == skippedTests
          ? _value.skippedTests
          : skippedTests // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<TestResult>,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestSuiteResultImplCopyWith<$Res>
    implements $TestSuiteResultCopyWith<$Res> {
  factory _$$TestSuiteResultImplCopyWith(_$TestSuiteResultImpl value,
          $Res Function(_$TestSuiteResultImpl) then) =
      __$$TestSuiteResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'total_tests') int totalTests,
      @JsonKey(name: 'passed_tests') int passedTests,
      @JsonKey(name: 'failed_tests') int failedTests,
      @JsonKey(name: 'skipped_tests') int skippedTests,
      Duration duration,
      List<TestResult> results,
      @JsonKey(name: 'executed_at') DateTime executedAt});
}

/// @nodoc
class __$$TestSuiteResultImplCopyWithImpl<$Res>
    extends _$TestSuiteResultCopyWithImpl<$Res, _$TestSuiteResultImpl>
    implements _$$TestSuiteResultImplCopyWith<$Res> {
  __$$TestSuiteResultImplCopyWithImpl(
      _$TestSuiteResultImpl _value, $Res Function(_$TestSuiteResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? totalTests = null,
    Object? passedTests = null,
    Object? failedTests = null,
    Object? skippedTests = null,
    Object? duration = null,
    Object? results = null,
    Object? executedAt = null,
  }) {
    return _then(_$TestSuiteResultImpl(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      totalTests: null == totalTests
          ? _value.totalTests
          : totalTests // ignore: cast_nullable_to_non_nullable
              as int,
      passedTests: null == passedTests
          ? _value.passedTests
          : passedTests // ignore: cast_nullable_to_non_nullable
              as int,
      failedTests: null == failedTests
          ? _value.failedTests
          : failedTests // ignore: cast_nullable_to_non_nullable
              as int,
      skippedTests: null == skippedTests
          ? _value.skippedTests
          : skippedTests // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<TestResult>,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestSuiteResultImpl extends _TestSuiteResult {
  const _$TestSuiteResultImpl(
      {@JsonKey(name: 'app_id') required this.appId,
      @JsonKey(name: 'total_tests') this.totalTests = 0,
      @JsonKey(name: 'passed_tests') this.passedTests = 0,
      @JsonKey(name: 'failed_tests') this.failedTests = 0,
      @JsonKey(name: 'skipped_tests') this.skippedTests = 0,
      this.duration = Duration.zero,
      final List<TestResult> results = const [],
      @JsonKey(name: 'executed_at') required this.executedAt})
      : _results = results,
        super._();

  factory _$TestSuiteResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestSuiteResultImplFromJson(json);

  @override
  @JsonKey(name: 'app_id')
  final String appId;
  @override
  @JsonKey(name: 'total_tests')
  final int totalTests;
  @override
  @JsonKey(name: 'passed_tests')
  final int passedTests;
  @override
  @JsonKey(name: 'failed_tests')
  final int failedTests;
  @override
  @JsonKey(name: 'skipped_tests')
  final int skippedTests;
  @override
  @JsonKey()
  final Duration duration;
  final List<TestResult> _results;
  @override
  @JsonKey()
  List<TestResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey(name: 'executed_at')
  final DateTime executedAt;

  @override
  String toString() {
    return 'TestSuiteResult(appId: $appId, totalTests: $totalTests, passedTests: $passedTests, failedTests: $failedTests, skippedTests: $skippedTests, duration: $duration, results: $results, executedAt: $executedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestSuiteResultImpl &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.totalTests, totalTests) ||
                other.totalTests == totalTests) &&
            (identical(other.passedTests, passedTests) ||
                other.passedTests == passedTests) &&
            (identical(other.failedTests, failedTests) ||
                other.failedTests == failedTests) &&
            (identical(other.skippedTests, skippedTests) ||
                other.skippedTests == skippedTests) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appId,
      totalTests,
      passedTests,
      failedTests,
      skippedTests,
      duration,
      const DeepCollectionEquality().hash(_results),
      executedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestSuiteResultImplCopyWith<_$TestSuiteResultImpl> get copyWith =>
      __$$TestSuiteResultImplCopyWithImpl<_$TestSuiteResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestSuiteResultImplToJson(
      this,
    );
  }
}

abstract class _TestSuiteResult extends TestSuiteResult {
  const factory _TestSuiteResult(
          {@JsonKey(name: 'app_id') required final String appId,
          @JsonKey(name: 'total_tests') final int totalTests,
          @JsonKey(name: 'passed_tests') final int passedTests,
          @JsonKey(name: 'failed_tests') final int failedTests,
          @JsonKey(name: 'skipped_tests') final int skippedTests,
          final Duration duration,
          final List<TestResult> results,
          @JsonKey(name: 'executed_at') required final DateTime executedAt}) =
      _$TestSuiteResultImpl;
  const _TestSuiteResult._() : super._();

  factory _TestSuiteResult.fromJson(Map<String, dynamic> json) =
      _$TestSuiteResultImpl.fromJson;

  @override
  @JsonKey(name: 'app_id')
  String get appId;
  @override
  @JsonKey(name: 'total_tests')
  int get totalTests;
  @override
  @JsonKey(name: 'passed_tests')
  int get passedTests;
  @override
  @JsonKey(name: 'failed_tests')
  int get failedTests;
  @override
  @JsonKey(name: 'skipped_tests')
  int get skippedTests;
  @override
  Duration get duration;
  @override
  List<TestResult> get results;
  @override
  @JsonKey(name: 'executed_at')
  DateTime get executedAt;
  @override
  @JsonKey(ignore: true)
  _$$TestSuiteResultImplCopyWith<_$TestSuiteResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
