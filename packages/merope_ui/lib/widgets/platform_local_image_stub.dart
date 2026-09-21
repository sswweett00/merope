import 'package:flutter/material.dart';

Widget platformLocalImage(String path, {BoxFit? fit}) {
  return Image.network(path, fit: fit);
}
