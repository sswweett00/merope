import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class FeedSkeleton extends StatelessWidget {
  final MeropeColorTokens tokens;
  const FeedSkeleton({super.key, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: tokens.surface,
        highlightColor: tokens.surfaceVariant,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 20, backgroundColor: Colors.white),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 100, height: 10, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 60, height: 8, color: Colors.white),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                  width: double.infinity, height: 12, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 200, height: 12, color: Colors.white),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
