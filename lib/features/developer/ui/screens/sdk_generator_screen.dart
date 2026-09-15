import 'package:flutter/material.dart';

class SdkGeneratorScreen extends StatelessWidget {
  final String ownerId;

  const SdkGeneratorScreen({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('SDK Generator')));
  }
}
