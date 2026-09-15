import 'package:freezed_annotation/freezed_annotation.dart';

part 'suspicious_account.freezed.dart';
part 'suspicious_account.g.dart';

enum ModerationReason {
  @JsonValue('bot')
  bot,
  @JsonValue('spam')
  spam,
  @JsonValue('harassment')
  harassment,
  @JsonValue('impersonation')
  impersonation,
  @JsonValue('csam')
  csam,
  @JsonValue('copyright')
  copyright,
  @JsonValue('misinformation')
  misinformation,
  @JsonValue('coordinated_inauthentic')
  coordinatedInauthentic,
}

enum RiskLevel { low, medium, high, critical }

enum AppealStatus { pending, approved, rejected, withdrawn }

enum LastAction { banned, warned, safe, escalated, underReview }

@freezed
class ModerationQueueItem with _$ModerationQueueItem {
  const factory ModerationQueueItem({
    required String userId,
    required String username,
    required String displayName,
    String? avatarUrl,
    required ModerationReason reason,
    required RiskLevel riskLevel,
    @Default(0.0) double botProbability,
    @Default(0.0) double trustScore,
    @Default(0) int reportCount,
    @Default([]) List<String> reporterIds,
    @Default([]) List<String> contentSampleIds,
    @Default([]) List<String> evidenceUrls,
    LastAction? lastAction,
    String? moderatorNote,
    @Default(false) bool isAppealed,
    AppealStatus? appealStatus,
    String? appealReason,
    @Default(0.0) double behavioralScore,
    @Default(0.0) double networkScore,
    @Default(0.0) double contentScore,
    @Default(0.0) double compositeScore,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ModerationQueueItem;

  factory ModerationQueueItem.fromJson(Map<String, dynamic> json) =>
      _$ModerationQueueItemFromJson(json);
}

@freezed
class SuspiciousAccount with _$SuspiciousAccount {
  const factory SuspiciousAccount({
    required String userId,
    required String username,
    required String displayName,
    String? avatarUrl,
    required ModerationReason reason,
    required RiskLevel riskLevel,
    @Default(0.0) double botProbability,
    @Default(0.0) double trustScore,
    @Default(0) int reportCount,
    @Default([]) List<String> reporterIds,
    @Default([]) List<String> contentSampleIds,
    @Default([]) List<String> evidenceUrls,
    LastAction? lastAction,
    String? moderatorNote,
    @Default(false) bool isAppealed,
    AppealStatus? appealStatus,
    String? appealReason,
    @Default(0.0) double behavioralScore,
    @Default(0.0) double networkScore,
    @Default(0.0) double contentScore,
    @Default(0.0) double compositeScore,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SuspiciousAccount;

  factory SuspiciousAccount.fromJson(Map<String, dynamic> json) =>
      _$SuspiciousAccountFromJson(json);
}
