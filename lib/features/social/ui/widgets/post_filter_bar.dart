import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import '../../logic/post_filter_provider.dart';

class PostFilterBar extends ConsumerWidget {
  const PostFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(postFilterProvider);

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          _FilterChip(
            label: 'All',
            filter: PostFilter.all,
            isActive: activeFilter == PostFilter.all,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Media',
            filter: PostFilter.media,
            isActive: activeFilter == PostFilter.media,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Interactive',
            filter: PostFilter.interactive,
            isActive: activeFilter == PostFilter.interactive,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Stories',
            filter: PostFilter.stories,
            isActive: activeFilter == PostFilter.stories,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends ConsumerWidget {
  final String label;
  final PostFilter filter;
  final bool isActive;

  const _FilterChip({
    required this.label,
    required this.filter,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFF5865F2);
    const surfaceColor = Color(0xFF161922);
    const textSecondary = Color(0xFF949BA4);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: MeropeTokens.durationFast,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              MeropeHaptics.trigger(MeropeTokens.hapticSoft);
              ref.read(postFilterProvider.notifier).state = filter;
            },
            borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? primaryColor : surfaceColor,
                borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
                border: Border.all(
                  color: isActive ? primaryColor : textSecondary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
