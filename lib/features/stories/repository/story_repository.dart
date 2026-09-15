import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/database/merope_database.dart' as db;
import 'package:merope_core/data/database/database_provider.dart';
import 'package:merope_models/stories/story_model.dart' as model;

abstract class IStoryRepository {
  Future<List<model.Story>> getStoryFeed();
  Future<model.Story?> getStory(String userId);
  Future<void> markStoryViewed(String storyId);
  Future<void> sendReaction(String storyId, String emoji);
  Future<String?> uploadStoryMedia(String filePath);
  Future<List<model.StoryUser>> getStoryViewers(String storyId);
}

class DriftStoryRepository implements IStoryRepository {
  DriftStoryRepository(this._db);
  final db.MeropeDatabase _db;

  @override
  Future<List<model.Story>> getStoryFeed() async {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(hours: 24));
    final query = _db.select(_db.stories)
      ..where((t) => t.expiresAt.isBiggerOrEqualValue(cutoff))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final rows = await query.get();

    return rows.map((row) {
      return model.Story(
        id: row.id,
        userId: row.userId,
        createdAt: row.createdAt,
        expiresAt: row.expiresAt,
        isViewed: row.isViewed,
        viewCount: row.viewCount,
        reactionCount: row.reactionCount,
        segments: const [],
      );
    }).toList();
  }

  @override
  Future<model.Story?> getStory(String userId) async {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(hours: 24));
    final query = _db.select(_db.stories)
      ..where((t) => t.userId.equals(userId) & t.expiresAt.isBiggerOrEqualValue(cutoff))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final rows = await query.get();

    if (rows.isEmpty) return null;
    final row = rows.first;

    final segmentsQuery = _db.select(_db.storySegments)
      ..where((t) => t.storyId.equals(row.id))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    final segmentRows = await segmentsQuery.get();

    final segments = segmentRows.map((s) {
      return model.StorySegment(
        id: s.id,
        storyId: s.storyId,
        mediaType: model.StoryMediaType.values.firstWhere(
          (e) => e.name == s.mediaType,
          orElse: () => model.StoryMediaType.image,
        ),
        mediaUrl: s.mediaUrl,
        thumbnailUrl: s.thumbnailUrl,
        duration: s.duration,
        textContent: s.textContent,
        createdAt: s.createdAt,
      );
    }).toList();

    return model.Story(
      id: row.id,
      userId: row.userId,
      segments: segments,
      createdAt: row.createdAt,
      expiresAt: row.expiresAt,
      isViewed: row.isViewed,
      viewCount: row.viewCount,
      reactionCount: row.reactionCount,
    );
  }

  @override
  Future<void> markStoryViewed(String storyId) async {
    await (_db.update(_db.stories)..where((t) => t.id.equals(storyId)))
        .write(const db.StoriesCompanion(
      isViewed: Value(true),
    ));

    await _db.into(_db.storyViews).insert(
      db.StoryViewsCompanion.insert(
        storyId: storyId,
        userId: 'current_user',
        viewedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> sendReaction(String storyId, String emoji) async {
    await _db.into(_db.storyReactions).insert(
      db.StoryReactionsCompanion.insert(
        id: '${storyId}_$emoji',
        storyId: storyId,
        userId: 'current_user',
        emoji: emoji,
        createdAt: DateTime.now(),
      ),
    );

    final row = await (_db.select(_db.stories)..where((t) => t.id.equals(storyId))).getSingle();
    await (_db.update(_db.stories)..where((t) => t.id.equals(storyId)))
        .write(db.StoriesCompanion(
      reactionCount: Value(row.reactionCount + 1),
    ));
  }

  @override
  Future<String?> uploadStoryMedia(String filePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://cdn.merope.app/stories/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  @override
  Future<List<model.StoryUser>> getStoryViewers(String storyId) async {
    final query = _db.select(_db.storyViews)
      ..where((t) => t.storyId.equals(storyId))
      ..orderBy([(t) => OrderingTerm.desc(t.viewedAt)]);
    final rows = await query.get();

    return rows.map((row) {
      return model.StoryUser(
        id: row.userId,
        username: row.userId,
        displayName: row.userId,
        isViewed: true,
      );
    }).toList();
  }
}

final storyRepositoryProvider = Provider<IStoryRepository>((ref) {
  return DriftStoryRepository(ref.read(meropeDatabaseProvider));
});
