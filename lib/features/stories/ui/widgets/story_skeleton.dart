import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class StorySkeleton extends StatelessWidget {
  final bool isTray;

  const StorySkeleton({super.key, this.isTray = false});

  @override
  Widget build(BuildContext context) {
    if (isTray) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF1E2230),
        highlightColor: const Color(0xFF2B2D31),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(width: MeropeTokens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 120, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 80, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E2230),
      highlightColor: const Color(0xFF2B2D31),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }
}
