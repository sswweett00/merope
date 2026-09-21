import 'dart:typed_data';

Future<Uint8List?> readImageSourceBytes(Object source) async {
  if (source is Uint8List) return source;
  final dynamic value = source;
  try {
    final bytes = await value.readAsBytes();
    if (bytes is List<int>) return Uint8List.fromList(bytes);
  } catch (_) {}
  return null;
}
