enum MessageBlockType {
  header,
  text,
  markdown,
  image,
  video,
  audio,
  code,
  quote,
  file,
  sticker,
  gif,
}

class MeropeMessage {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final List<MessageBlock> blocks;
  final String channelId;
  final int createdAt;
  final int updatedAt;
  final bool isEncrypted;
  final List<String> reactions;
  final String? threadId;
  final String? effect;
  final int version;
  final String? parentMessageId;
  final String? messageType;
  final String? fileUrl;
  final String? encryptedPayload;
  final Map<String, dynamic>? metadata;

  const MeropeMessage({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.blocks,
    required this.channelId,
    required this.createdAt,
    required this.updatedAt,
    this.isEncrypted = false,
    this.reactions = const [],
    this.threadId,
    this.effect,
    this.version = 1,
    this.parentMessageId,
    this.messageType,
    this.fileUrl,
    this.encryptedPayload,
    this.metadata,
  });

  MeropeMessage copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    List<MessageBlock>? blocks,
    String? channelId,
    int? createdAt,
    int? updatedAt,
    bool? isEncrypted,
    List<String>? reactions,
    String? threadId,
    String? effect,
    int? version,
    String? parentMessageId,
    String? messageType,
    String? fileUrl,
    String? encryptedPayload,
    Map<String, dynamic>? metadata,
  }) {
    return MeropeMessage(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      blocks: blocks ?? this.blocks,
      channelId: channelId ?? this.channelId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      reactions: reactions ?? this.reactions,
      threadId: threadId ?? this.threadId,
      effect: effect ?? this.effect,
      version: version ?? this.version,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      messageType: messageType ?? this.messageType,
      fileUrl: fileUrl ?? this.fileUrl,
      encryptedPayload: encryptedPayload ?? this.encryptedPayload,
      metadata: metadata ?? this.metadata,
    );
  }

  factory MeropeMessage.fromJson(Map<String, dynamic> json) => MeropeMessage(
    id: json['id'] as String,
    authorId: (json['author_id'] ?? json['authorId']) as String,
    authorName: (json['author_username'] ?? json['authorName']) as String,
    authorAvatar: (json['author_avatar_url'] ?? json['authorAvatar'] ?? '') as String,
    blocks: (json['blocks'] as List<dynamic>?)?.map((e) => MessageBlock.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    channelId: (json['room_id'] ?? json['channelId']) as String,
    createdAt: (json['timestamp'] ?? json['createdAt']) as int,
    updatedAt: (json['updated_at'] ?? json['updatedAt'] ?? 0) as int,
    isEncrypted: (json['is_encrypted'] ?? json['isEncrypted']) as bool? ?? false,
    reactions: (json['reactions'] as List<dynamic>?)?.cast<String>() ?? [],
    threadId: (json['thread_id'] ?? json['threadId']) as String?,
    effect: json['effect'] as String?,
    version: json['version'] as int? ?? 1,
    parentMessageId: (json['parent_id'] ?? json['parentMessageId']) as String?,
    messageType: (json['type'] ?? json['messageType']) as String?,
    fileUrl: (json['file_url'] ?? json['fileUrl']) as String?,
    encryptedPayload: json['encrypted_payload'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'authorId': authorId,
    'authorName': authorName,
    'authorAvatar': authorAvatar,
    'blocks': blocks.map((e) => e.toJson()).toList(),
    'channelId': channelId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isEncrypted': isEncrypted,
    'reactions': reactions,
    'threadId': threadId,
    'effect': effect,
    'version': version,
    'parentMessageId': parentMessageId,
    'messageType': messageType,
    'fileUrl': fileUrl,
    if (encryptedPayload != null) 'encrypted_payload': encryptedPayload,
    if (metadata != null) 'metadata': metadata,
  };
}

class MessageBlock {
  final MessageBlockType type;
  final String content;
  final Map<String, dynamic>? metadata;

  const MessageBlock({
    required this.type,
    required this.content,
    this.metadata,
  });

  factory MessageBlock.fromJson(Map<String, dynamic> json) => MessageBlock(
    type: MessageBlockType.values.firstWhere(
      (e) => e.name == json['type'] as String,
      orElse: () => MessageBlockType.text,
    ),
    content: json['content'] as String,
    metadata: json['metadata'] as Map<String, dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'content': content,
    if (metadata != null) 'metadata': metadata,
  };
}
