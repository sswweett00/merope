import 'package:merope_core/plugins/media_compression_isolate.dart';

Future<String> compressMediaForTheme(String path) =>
    MediaCompressionIsolate.compressMedia(path);
