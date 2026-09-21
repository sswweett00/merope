import 'dart:io';

import 'package:flutter/material.dart';

Widget platformLocalImage(String path, {BoxFit? fit}) {
  return Image.file(File(path), fit: fit);
}
