import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'merope_database.dart';

final meropeDatabaseProvider = Provider<MeropeDatabase>((ref) {
  return MeropeDatabase();
});
