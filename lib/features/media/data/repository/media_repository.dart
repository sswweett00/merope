import 'package:merope_core/data/database/merope_database.dart' as db;
import '../../domain/models/media_models.dart';

abstract class IMediaRepository {
  Future<List<MeropeTrack>> getTracks();
  Future<List<MeropePlaylist>> getPlaylists();
  Future<void> createPlaylist(MeropePlaylist playlist);
  Future<void> addTrackToPlaylist(String playlistId, String trackId);
}

class DriftMediaRepository implements IMediaRepository {
  final db.MeropeDatabase _db;

  DriftMediaRepository(this._db);

  @override
  Future<List<MeropeTrack>> getTracks() async {
    final rows = await _db.select(_db.audioTracks).get();
    return rows
        .map((row) => MeropeTrack(
              id: row.id,
              title: row.title,
              artist: row.artist,
              audioUrl: row.audioUrl,
              durationSeconds: row.durationSeconds,
            ))
        .toList();
  }

  @override
  Future<List<MeropePlaylist>> getPlaylists() async {
    final rows = await _db.select(_db.playlists).get();
    return rows
        .map((row) => MeropePlaylist(
              id: row.id,
              ownerId: row.ownerId,
              title: row.title,
              trackIds: row.trackIds.split(','),
              totalDurationSeconds: 0,
            ))
        .toList();
  }

  @override
  Future<void> createPlaylist(MeropePlaylist playlist) async {
    await _db.into(_db.playlists).insert(
          db.PlaylistsCompanion.insert(
            id: playlist.id,
            ownerId: playlist.ownerId,
            title: playlist.title,
            trackIds: playlist.trackIds.join(','),
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    // Logic for adding track to playlist junction
  }
}
