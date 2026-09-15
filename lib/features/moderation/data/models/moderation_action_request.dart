import 'package:freezed_annotation/freezed_annotation.dart';

part 'moderation_action_request.freezed.dart';
part 'moderation_action_request.g.dart';

enum ModerationActionType { ban, markSafe, escalate, warn, review }

@freezed
class ModerationActionRequest with _$ModerationActionRequest {
  const factory ModerationActionRequest({
    required ModerationActionType type,
    required String userId,
    String? reason,
    int? durationDays,
    String? escalationTarget,
    String? moderatorNote,
    @Default({}) Map<String, dynamic> metadata,
  }) = _ModerationActionRequest;

  factory ModerationActionRequest.fromJson(Map<String, dynamic> json) =>
      _$ModerationActionRequestFromJson(json);
}

@freezed
class BulkModerationActionRequest with _$BulkModerationActionRequest {
  const factory BulkModerationActionRequest({
    required ModerationActionType type,
    required List<String> userIds,
    String? reason,
    int? durationDays,
    String? moderatorNote,
    @Default({}) Map<String, dynamic> metadata,
  }) = _BulkModerationActionRequest;

  factory BulkModerationActionRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkModerationActionRequestFromJson(json);
}
