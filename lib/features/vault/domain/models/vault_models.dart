enum VaultItemType { file, folder, key, secret }

class VaultItem {
  final String id;
  final String title;
  final VaultItemType type;
  final String protection;
  final String? parentId;
  final bool isFavorite;
  final DateTime? lastAccessed;

  const VaultItem({
    required this.id,
    required this.title,
    required this.type,
    required this.protection,
    this.parentId,
    this.isFavorite = false,
    this.lastAccessed,
  });

  VaultItem copyWith({
    String? id,
    String? title,
    VaultItemType? type,
    String? protection,
    String? parentId,
    bool? isFavorite,
    DateTime? lastAccessed,
  }) {
    return VaultItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      protection: protection ?? this.protection,
      parentId: parentId ?? this.parentId,
      isFavorite: isFavorite ?? this.isFavorite,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }

  factory VaultItem.fromJson(Map<String, dynamic> json) {
    return VaultItem(
      id: json['id'] as String,
      title: json['title'] as String,
      type: VaultItemType.values
          .firstWhere((e) => e.name == json['type'] as String),
      protection: json['protection'] as String,
      parentId: json['parentId'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastAccessed: json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'protection': protection,
      'parentId': parentId,
      'isFavorite': isFavorite,
      'lastAccessed': lastAccessed?.toIso8601String(),
    };
  }
}
