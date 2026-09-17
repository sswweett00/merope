class Conversation {
  final String id;
  final String? avatarUrl;
  final String description;
  final String title;
  final int lastActivity;
  final String? lastMessage;
  final List<String> participants;
  final int unreadCount;

  const Conversation({
    required this.id,
    this.avatarUrl,
    this.description = '',
    required this.title,
    required this.lastActivity,
    this.lastMessage,
    required this.participants,
    this.unreadCount = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'] as String,
        avatarUrl: (json['other_user_avatar'] ?? json['avatarUrl']) as String?,
        description: json['description'] as String? ?? '',
        title: (json['other_user_name'] ?? json['title']) as String,
        lastActivity:
            (json['last_message_timestamp'] ?? json['lastActivity']) as int,
        lastMessage: (json['last_message'] ?? json['lastMessage']) as String?,
        participants:
            (json['participants'] as List<dynamic>?)?.cast<String>() ??
                [json['other_user_id'] as String? ?? ''],
        unreadCount: (json['unread_count'] ?? json['unreadCount']) as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatarUrl': avatarUrl,
        'description': description,
        'title': title,
        'lastActivity': lastActivity,
        'lastMessage': lastMessage,
        'participants': participants,
        'unreadCount': unreadCount,
      };
}

class ChatFolder {
  final String id;
  final String name;
  final List<String> conversationIds;
  final DateTime createdAt;

  const ChatFolder({
    required this.id,
    required this.name,
    required this.conversationIds,
    required this.createdAt,
  });

  factory ChatFolder.fromJson(Map<String, dynamic> json) => ChatFolder(
        id: json['id'] as String,
        name: json['name'] as String,
        conversationIds:
            (json['conversationIds'] as List<dynamic>?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'conversationIds': conversationIds,
        'createdAt': createdAt.toIso8601String(),
      };
}

class TypingIndicator {
  final String conversationId;
  final List<String> userIds;

  const TypingIndicator({
    required this.conversationId,
    required this.userIds,
  });

  factory TypingIndicator.fromJson(Map<String, dynamic> json) =>
      TypingIndicator(
        conversationId: json['conversationId'] as String,
        userIds: (json['userIds'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'userIds': userIds,
      };
}

class MessageReaction {
  final String emoji;
  final int count;
  final List<String> userIds;

  const MessageReaction({
    required this.emoji,
    required this.count,
    required this.userIds,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      MessageReaction(
        emoji: json['emoji'] as String,
        count: json['count'] as int,
        userIds: (json['userIds'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'count': count,
        'userIds': userIds,
      };
}
