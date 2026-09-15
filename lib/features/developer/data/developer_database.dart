import 'package:drift/drift.dart';
import 'developer_database_io.dart' if (dart.library.html) 'developer_database_web.dart' as platform;

part 'developer_database.g.dart';

class DeveloperApps extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get clientId => text()();
  TextColumn get clientIdNormalized => text().customConstraint('UNIQUE NOT NULL')();
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {id},
    {clientIdNormalized},
  ];
}

class ApiKeys extends Table {
  TextColumn get id => text()();
  TextColumn get appId => text()();
  TextColumn get keyPrefix => text()();
  TextColumn get name => text()();
  TextColumn get scopes => text().nullable()();
  TextColumn get data => text()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [{id}];
}

class Webhooks extends Table {
  TextColumn get id => text()();
  TextColumn get appId => text()();
  TextColumn get name => text()();
  TextColumn get targetUrl => text()();
  TextColumn get events => text().nullable()();
  TextColumn get data => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class WebhookDeliveryLogs extends Table {
  TextColumn get id => text()();
  TextColumn get webhookId => text()();
  TextColumn get payload => text()();
  IntColumn get statusCode => integer()();
  BoolColumn get success => boolean()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get deliveredAt => dateTime()();
}

class Bots extends Table {
  TextColumn get id => text()();
  TextColumn get appId => text()();
  TextColumn get name => text()();
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class MetricDataPoints extends Table {
  TextColumn get id => text()();
  TextColumn get appId => text()();
  TextColumn get period => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get value => real()();
  TextColumn get label => text().nullable()();
  TextColumn get metricKey => text()();
}

@DriftDatabase(tables: [
  DeveloperApps,
  ApiKeys,
  Webhooks,
  WebhookDeliveryLogs,
  Bots,
  MetricDataPoints,
])
class DeveloperDatabase extends _$DeveloperDatabase {
  DeveloperDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );
}

QueryExecutor _openConnection() {
  return platform.openDeveloperConnection();
}
