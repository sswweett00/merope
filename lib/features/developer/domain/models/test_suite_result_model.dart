import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_suite_result_model.freezed.dart';
part 'test_suite_result_model.g.dart';

enum TestStatus { passed, failed, skipped }

@freezed
class TestResult with _$TestResult {
  const factory TestResult({
    @JsonKey(name: 'test_name') required String testName,
    required TestStatus status,
    required Duration duration,
    String? error,
    @JsonKey(name: 'response') Map<String, dynamic>? response,
  }) = _TestResult;

  factory TestResult.fromJson(Map<String, dynamic> json) => _$TestResultFromJson(json);
}

@freezed
class TestSuiteResult with _$TestSuiteResult {
  const TestSuiteResult._();

  const factory TestSuiteResult({
    @JsonKey(name: 'app_id') required String appId,
    @JsonKey(name: 'total_tests') @Default(0) int totalTests,
    @JsonKey(name: 'passed_tests') @Default(0) int passedTests,
    @JsonKey(name: 'failed_tests') @Default(0) int failedTests,
    @JsonKey(name: 'skipped_tests') @Default(0) int skippedTests,
    @Default(Duration.zero) Duration duration,
    @Default([]) List<TestResult> results,
    @JsonKey(name: 'executed_at') required DateTime executedAt,
  }) = _TestSuiteResult;

  factory TestSuiteResult.fromJson(Map<String, dynamic> json) => _$TestSuiteResultFromJson(json);

  double get passRate {
    if (totalTests == 0) return 0.0;
    return (passedTests / totalTests) * 100;
  }

  bool get allPassed => failedTests == 0 && totalTests > 0;
}
