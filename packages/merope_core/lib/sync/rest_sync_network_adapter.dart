import 'dart:developer' as developer;
import '../data/services/api_client.dart';
import 'operation_log.dart';
import 'sync_engine.dart';

class RestSyncNetworkAdapter implements ISyncNetworkAdapter {
  final ApiClient _apiClient;

  RestSyncNetworkAdapter(this._apiClient);

  @override
  Future<bool> sendOperation(OperationLogEntry entry) async {
    try {
      developer.log('SyncEngine: Sending operation ${entry.id} (${entry.type.name})', name: 'SyncNetwork');

      final response = await _apiClient.post(
        '/sync/operation',
        data: entry.toJson(),
      );

      if (response.isSuccess) {
        developer.log('SyncEngine: Successfully synced ${entry.id}', name: 'SyncNetwork');
        return true;
      } else {
        developer.log('SyncEngine: Failed to sync ${entry.id}. Status: ${response.statusCode}, Error: ${response.error}', name: 'SyncNetwork');

        // If error is 4xx (except 401/403/429), it might be a client error, don't retry indefinitely
        if (response.statusCode != null && response.statusCode! >= 400 && response.statusCode! < 500) {
           if (response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 429) {
             return false; // Retryable transient error
           }
           // Permanent client error, return true to "discard" from queue or handle specially
           // For simplicity, we return false and let SyncEngine handle retry logic
           return false;
        }
        return false;
      }
    } catch (e) {
      developer.log('SyncEngine: Unexpected error sending operation ${entry.id}: $e', name: 'SyncNetwork', error: e);
      return false;
    }
  }
}
