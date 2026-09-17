import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/developer_database.dart';
import '../data/datasources/developer_local_datasource.dart';
import '../data/datasources/developer_remote_datasource.dart';
import '../data/repositories/developer_repository.dart';
import '../data/repositories/developer_repository_impl.dart';

final developerDatabaseProvider = Provider<DeveloperDatabase>((ref) {
  final db = DeveloperDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final developerLocalDataSourceProvider =
    Provider<DeveloperLocalDataSource>((ref) {
  final db = ref.watch(developerDatabaseProvider);
  return DriftDeveloperLocalDataSource(db);
});

final developerRemoteDataSourceProvider =
    Provider<DeveloperRemoteDataSource>((ref) {
  return DeveloperRemoteDataSourceImpl();
});

final developerRepositoryProvider = Provider<IDeveloperRepository>((ref) {
  return DeveloperRepositoryImpl(
    remote: ref.watch(developerRemoteDataSourceProvider),
    local: ref.watch(developerLocalDataSourceProvider),
  );
});
