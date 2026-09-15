import 'package:merope_models/social/post_model.dart';

abstract class ISocialRepository {
  Future<List<MeropeSignal>> getTimeline();
  Future<void> savePost(MeropeSignal signal);
}

class DriftSocialRepository implements ISocialRepository {
  DriftSocialRepository();

  @override
  Future<List<MeropeSignal>> getTimeline() async {
    // In a real app, fetch from database or API
    return [];
  }

  @override
  Future<void> savePost(MeropeSignal signal) async {
    // Save to local operation log for syncing
  }
}
