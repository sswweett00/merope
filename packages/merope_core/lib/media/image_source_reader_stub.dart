import 'dart:typed_data';

import 'package:dio/dio.dart';

Future<Uint8List?> readImageSourceBytes(Object source) async {
  if (source is Uint8List) return source;
  if (source is String && source.isNotEmpty) {
    try {
      final response = await Dio().get<List<int>>(
        source,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data != null) return Uint8List.fromList(response.data!);
    } catch (_) {}
  }
  final dynamic value = source;
  try {
    final bytes = await value.readAsBytes();
    if (bytes is List<int>) return Uint8List.fromList(bytes);
  } catch (_) {}
  return null;
}
