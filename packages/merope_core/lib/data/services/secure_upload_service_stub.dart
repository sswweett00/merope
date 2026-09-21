import 'dart:typed_data';

class SecureUploadService {
  Future<void> uploadToPhantomMesh(String filePath) async {
    throw UnsupportedError('Phantom Mesh upload is not available on web');
  }

  Future<Uint8List> reconstructFromMesh(
    Map<int, String> gatheredShards,
  ) async {
    if (gatheredShards.length < 2) {
      throw ArgumentError('At least two shards are required');
    }
    throw UnsupportedError('Phantom Mesh reconstruction is not available on web');
  }
}
