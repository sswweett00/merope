// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_suite_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestResultImpl _$$TestResultImplFromJson(Map<String, dynamic> json) =>
    _$TestResultImpl(
      testName: json['test_name'] as String,
      status: $enumDecode(_$TestStatusEnumMap, json['status']),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      error: json['error'] as String?,
      response: json['response'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TestResultImplToJson(_$TestResultImpl instance) =>
    <String, dynamic>{
      'test_name': instance.testName,
      'status': _$TestStatusEnumMap[instance.status]!,
      'duration': instance.duration.inMicroseconds,
      'error': instance.error,
      'response': instance.response,
    };

const _$TestStatusEnumMap = {
  TestStatus.passed: 'passed',
  TestStatus.failed: 'failed',
  TestStatus.skipped: 'skipped',
};

_$TestSuiteResultImpl _$$TestSuiteResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TestSuiteResultImpl(
      appId: json['app_id'] as String,
      totalTests: (json['total_tests'] as num?)?.toInt() ?? 0,
      passedTests: (json['passed_tests'] as num?)?.toInt() ?? 0,
      failedTests: (json['failed_tests'] as num?)?.toInt() ?? 0,
      skippedTests: (json['skipped_tests'] as num?)?.toInt() ?? 0,
      duration: json['duration'] == null
          ? Duration.zero
          : Duration(microseconds: (json['duration'] as num).toInt()),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => TestResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      executedAt: DateTime.parse(json['executed_at'] as String),
    );

Map<String, dynamic> _$$TestSuiteResultImplToJson(
        _$TestSuiteResultImpl instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'total_tests': instance.totalTests,
      'passed_tests': instance.passedTests,
      'failed_tests': instance.failedTests,
      'skipped_tests': instance.skippedTests,
      'duration': instance.duration.inMicroseconds,
      'results': instance.results,
      'executed_at': instance.executedAt.toIso8601String(),
    };
