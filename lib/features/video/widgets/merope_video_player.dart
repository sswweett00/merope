import 'package:flutter/material.dart';

class MeropeVideoPlayer extends StatelessWidget {
  final String videoId;
  final String url;
  final bool autoPlay;
  final BoxFit? fit;

  const MeropeVideoPlayer({
    super.key,
    required this.videoId,
    required this.url,
    this.autoPlay = false,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Icon(Icons.play_circle_outline, size: 64, color: Colors.white54),
      ),
    );
  }
}
