import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/developer_module_providers.dart';
import '../../domain/models/developer_metrics_model.dart';

final developerMetricsProvider =
    StreamProvider.family<DeveloperMetrics, String>((ref, appId) {
  final repo = ref.watch(developerRepositoryProvider);
  final local = ref.watch(developerLocalDataSourceProvider);

  final remoteStream = Stream.periodic(const Duration(seconds: 5), (_) => appId)
      .asyncMap((_) => repo.getMetrics(appId, 'realtime'));

  final localStream =
      local.watchMetrics(appId, 'realtime').map((points) => DeveloperMetrics(
            appId: appId,
            period: 'realtime',
            dataPoints: points,
          ));

  final controller = StreamController<DeveloperMetrics>();

  final sub = remoteStream.listen(controller.add, onError: controller.addError);
  final localSub = localStream.listen((_) {});

  ref.onDispose(() {
    sub.cancel();
    localSub.cancel();
    controller.close();
  });

  return controller.stream;
});
