import 'package:drift/drift.dart';
import 'merope_database_io.dart'
    if (dart.library.html) 'merope_database_web.dart';

part 'merope_database.g.dart';

class OperationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get performedBy => text()();
  DateTimeColumn get performedAt => dateTime()();
  TextColumn get metadata => text().nullable()();
  IntColumn get clientSequence => integer().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get passwordHash => text()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {username},
        {email}
      ];
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text()();
  TextColumn get authorId => text()();
  TextColumn get authorName => text().nullable()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(false))();
  TextColumn get reactions => text().nullable()();
  TextColumn get threadId => text().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  // Apex Refinement: Composite Index for fast channel message retrieval
  @override
  List<Set<Column>> get uniqueKeys => [
        {id}
      ];
}

class SubCommunities extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get description => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get bannerUrl => text().nullable()();
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class CommunityMembers extends Table {
  TextColumn get id => text()();
  TextColumn get communityId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text()();
  DateTimeColumn get joinedAt => dateTime()();
}

class CommunityEvents extends Table {
  TextColumn get id => text()();
  TextColumn get creatorId => text()();
  TextColumn get communityId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get locationName => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class Collectives extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get description => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get category => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class CollectiveThreads extends Table {
  TextColumn get id => text()();
  TextColumn get collectiveId => text()();
  TextColumn get authorId => text()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  IntColumn get resonance => integer().withDefault(const Constant(0))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

class ThreadReplies extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  TextColumn get authorId => text()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get content => text()();
  IntColumn get resonance => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get fromAccountId => text()();
  TextColumn get toAccountId => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  RealColumn get fee => real().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get receiptUrl => text().nullable()();
  RealColumn get fraudScore => real().nullable()();
  TextColumn get metadata => text().nullable()();
}

class AudioTracks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get audioUrl => text()();
  IntColumn get durationSeconds => integer()();
}

class Playlists extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get title => text()();
  TextColumn get trackIds => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class Stories extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  IntColumn get viewCount => integer().withDefault(const Constant(0))();
  IntColumn get reactionCount => integer().withDefault(const Constant(0))();
  BoolColumn get isViewed => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {id}
      ];
}

class StorySegments extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text()();
  TextColumn get mediaType => text()();
  TextColumn get mediaUrl => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get duration => integer().withDefault(const Constant(5))();
  TextColumn get textContent => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {id}
      ];
}

class StoryViews extends Table {
  TextColumn get storyId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get viewedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {storyId, userId}
      ];
}

class StoryReactions extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text()();
  TextColumn get userId => text()();
  TextColumn get emoji => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {id}
      ];
}

@DriftDatabase(
  tables: [
    OperationLogs,
    Users,
    Messages,
    SubCommunities,
    CommunityMembers,
    CommunityEvents,
    Collectives,
    CollectiveThreads,
    ThreadReplies,
    Transactions,
    AudioTracks,
    Playlists,
    Stories,
    StorySegments,
    StoryViews,
    StoryReactions,
  ],
)
class MeropeDatabase extends _$MeropeDatabase {
  MeropeDatabase() : super(openConnection());

  @override
  int get schemaVersion => 4; // Incremented for Stories module

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 4) {
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_stories_user_created ON stories (user_id, created_at DESC)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_stories_expires ON stories (expires_at)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_story_segments_story ON story_segments (story_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_story_views_story ON story_views (story_id, viewed_at DESC)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_story_reactions_story ON story_reactions (story_id)');
          }
          if (from < 3) {
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_transactions_user_created ON transactions (to_account_id, created_at DESC)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_transactions_from_account ON transactions (from_account_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions (status)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_transactions_currency ON transactions (currency)');
            await customStatement(
                'ALTER TABLE transactions ADD COLUMN fee REAL');
            await customStatement(
                'ALTER TABLE transactions ADD COLUMN category TEXT');
            await customStatement(
                'ALTER TABLE transactions ADD COLUMN receipt_url TEXT');
            await customStatement(
                'ALTER TABLE transactions ADD COLUMN fraud_score REAL');
            await customStatement(
                'ALTER TABLE transactions ADD COLUMN metadata TEXT');
          }
          if (from < 2) {
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_messages_channel ON messages (channel_id, created_at DESC)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_users_username ON users (username)');
          }
        },
      );
}
