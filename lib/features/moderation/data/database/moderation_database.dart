import 'package:drift/drift.dart';
import 'moderation_database_io.dart';

part 'moderation_database.g.dart';

class ModerationQueueCache extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get username => text()();
  TextColumn get displayName => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get reason => text()();
  TextColumn get riskLevel => text()();
  RealColumn get botProbability => real()();
  RealColumn get trustScore => real()();
  IntColumn get reportCount => integer()();
  TextColumn get reporterIds => text()();
  TextColumn get contentSampleIds => text()();
  TextColumn get evidenceUrls => text()();
  TextColumn get lastAction => text().nullable()();
  TextColumn get moderatorNote => text().nullable()();
  BoolColumn get isAppealed => boolean()();
  TextColumn get appealStatus => text().nullable()();
  TextColumn get appealReason => text().nullable()();
  RealColumn get behavioralScore => real()();
  RealColumn get networkScore => real()();
  RealColumn get contentScore => real()();
  RealColumn get compositeScore => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [{id}];
}

class ModerationActionLog extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get actionType => text()();
  TextColumn get moderatorId => text()();
  TextColumn get moderatorNote => text().nullable()();
  TextColumn get metadata => text().nullable()();
  DateTimeColumn get performedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [{id}];
}

class ModerationSavedFilter extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get riskLevels => text()();
  TextColumn get reasons => text()();
  TextColumn get dateRange => text().nullable()();
  TextColumn get searchQuery => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [{id}];
}

@DriftDatabase(tables: [
  ModerationQueueCache,
  ModerationActionLog,
  ModerationSavedFilter,
])
class ModerationDatabase extends _$ModerationDatabase {
  ModerationDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 1) {
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_mod_queue_risk ON moderation_queue_cache (risk_level, created_at DESC)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_mod_queue_synced ON moderation_queue_cache (is_synced)');
          }
        },
      );
}
