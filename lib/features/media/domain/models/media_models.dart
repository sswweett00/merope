class MeropeTrack {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String? coverUrl;
  final String audioUrl;
  final int durationSeconds;
  final bool isLiked;

  const MeropeTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.coverUrl,
    required this.audioUrl,
    this.durationSeconds = 0,
    this.isLiked = false,
  });

  factory MeropeTrack.fromJson(Map<String, dynamic> json) => MeropeTrack(
    id: json['id'] as String,
    title: json['title'] as String,
    artist: json['artist'] as String,
    album: json['album'] as String?,
    coverUrl: json['coverUrl'] as String?,
    audioUrl: json['audioUrl'] as String,
    durationSeconds: json['durationSeconds'] as int? ?? 0,
    isLiked: json['isLiked'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'album': album,
    'coverUrl': coverUrl,
    'audioUrl': audioUrl,
    'durationSeconds': durationSeconds,
    'isLiked': isLiked,
  };
}

class MeropePlaylist {
  final String id;
  final String ownerId;
  final String title;
  final String? description;
  final String? coverUrl;
  final List<String> trackIds;
  final int totalDurationSeconds;
  final bool isPublic;

  const MeropePlaylist({
    required this.id,
    required this.ownerId,
    required this.title,
    this.description,
    this.coverUrl,
    this.trackIds = const [],
    this.totalDurationSeconds = 0,
    this.isPublic = false,
  });

  factory MeropePlaylist.fromJson(Map<String, dynamic> json) => MeropePlaylist(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    coverUrl: json['coverUrl'] as String?,
    trackIds: (json['trackIds'] as List<dynamic>?)?.cast<String>() ?? [],
    totalDurationSeconds: json['totalDurationSeconds'] as int? ?? 0,
    isPublic: json['isPublic'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerId': ownerId,
    'title': title,
    'description': description,
    'coverUrl': coverUrl,
    'trackIds': trackIds,
    'totalDurationSeconds': totalDurationSeconds,
    'isPublic': isPublic,
  };
}

enum PlaybackState { playing, paused, buffering, idle }
enum RepeatMode { off, one, all }

class AudioPlayerState {
  final MeropeTrack? currentTrack;
  final List<MeropeTrack> queue;
  final PlaybackState status;
  final double progress;
  final Duration position;
  final Duration duration;
  final bool isShuffle;
  final RepeatMode repeat;

  const AudioPlayerState({
    this.currentTrack,
    this.queue = const [],
    this.status = PlaybackState.idle,
    this.progress = 0.0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isShuffle = false,
    this.repeat = RepeatMode.off,
  });

  AudioPlayerState copyWith({
    MeropeTrack? currentTrack,
    List<MeropeTrack>? queue,
    PlaybackState? status,
    double? progress,
    Duration? position,
    Duration? duration,
    bool? isShuffle,
    RepeatMode? repeat,
  }) {
    return AudioPlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      queue: queue ?? this.queue,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isShuffle: isShuffle ?? this.isShuffle,
      repeat: repeat ?? this.repeat,
    );
  }
}

class MediaMetadata {
  final String id;
  final String originalName;
  final String storedName;
  final String storageKey;
  final String storageUrl;
  final String mimeType;
  final int fileSize;
  final int? width;
  final int? height;
  final int? duration;
  final String? thumbnailUrl;
  final String uploaderId;
  final bool isPublic;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? altText;
  final String? description;
  final List<String> tags;
  final String category;
  final String processingStatus;

  const MediaMetadata({
    required this.id,
    required this.originalName,
    required this.storedName,
    required this.storageKey,
    required this.storageUrl,
    required this.mimeType,
    required this.fileSize,
    this.width,
    this.height,
    this.duration,
    this.thumbnailUrl,
    required this.uploaderId,
    required this.isPublic,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.altText,
    this.description,
    this.tags = const [],
    required this.category,
    required this.processingStatus,
  });

  factory MediaMetadata.fromJson(Map<String, dynamic> json) => MediaMetadata(
    id: json['id'] as String,
    originalName: json['originalName'] as String,
    storedName: json['storedName'] as String,
    storageKey: json['storageKey'] as String,
    storageUrl: json['storageUrl'] as String,
    mimeType: json['mimeType'] as String,
    fileSize: json['fileSize'] as int,
    width: json['width'] as int?,
    height: json['height'] as int?,
    duration: json['duration'] as int?,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    uploaderId: json['uploaderId'] as String,
    isPublic: json['isPublic'] as bool? ?? false,
    expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    altText: json['altText'] as String?,
    description: json['description'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    category: json['category'] as String,
    processingStatus: json['processingStatus'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'originalName': originalName,
    'storedName': storedName,
    'storageKey': storageKey,
    'storageUrl': storageUrl,
    'mimeType': mimeType,
    'fileSize': fileSize,
    'width': width,
    'height': height,
    'duration': duration,
    'thumbnailUrl': thumbnailUrl,
    'uploaderId': uploaderId,
    'isPublic': isPublic,
    'expiresAt': expiresAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'altText': altText,
    'description': description,
    'tags': tags,
    'category': category,
    'processingStatus': processingStatus,
  };
}

class MediaTransformation {
  final String id;
  final String mediaId;
  final String type;
  final Map<String, dynamic> parameters;
  final String status;
  final String? resultUrl;
  final DateTime createdAt;
  final DateTime? completedAt;

  const MediaTransformation({
    required this.id,
    required this.mediaId,
    required this.type,
    required this.parameters,
    required this.status,
    this.resultUrl,
    required this.createdAt,
    this.completedAt,
  });

  factory MediaTransformation.fromJson(Map<String, dynamic> json) => MediaTransformation(
    id: json['id'] as String,
    mediaId: json['mediaId'] as String,
    type: json['type'] as String,
    parameters: json['parameters'] as Map<String, dynamic>,
    status: json['status'] as String,
    resultUrl: json['resultUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'mediaId': mediaId,
    'type': type,
    'parameters': parameters,
    'status': status,
    'resultUrl': resultUrl,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };
}

class UploadResult {
  final String mediaId;
  final String mediaUrl;
  final String? thumbnailUrl;
  final String mimeType;
  final int? width;
  final int? height;
  final int? duration;

  const UploadResult({
    required this.mediaId,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.mimeType,
    this.width,
    this.height,
    this.duration,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) => UploadResult(
    mediaId: json['mediaId'] as String,
    mediaUrl: json['mediaUrl'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    mimeType: json['mimeType'] as String,
    width: json['width'] as int?,
    height: json['height'] as int?,
    duration: json['duration'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'mediaId': mediaId,
    'mediaUrl': mediaUrl,
    'thumbnailUrl': thumbnailUrl,
    'mimeType': mimeType,
    'width': width,
    'height': height,
    'duration': duration,
  };
}
