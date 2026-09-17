import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_models/stories/story_model.dart' as model;
import '../../data/providers/stories_provider.dart';

class StoryTray extends ConsumerWidget {
  const StoryTray({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(storyFeedProvider);
    final tokens = ref.watch(themeProvider).currentTokens;

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: feedAsync.when(
        data: (users) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return _StoryItem(user: users[index], tokens: tokens);
          },
        ),
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (context, index) => _StorySkeleton(tokens: tokens),
        ),
        error: (err, _) =>
            Center(child: Text('!', style: TextStyle(color: tokens.error))),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({required this.user, required this.tokens});
  final model.StoryUser user;
  final MeropeColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    final borderColor = user.isViewed ? tokens.border : tokens.primary;

    return GestureDetector(
      onTap: () => context.push('/story/${user.id}'),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 76,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: MeropeImage.avatar(
                imageUrl: user.avatarUrl,
                radius: 30,
                initials: user.displayName ?? user.username,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.isMe ? 'Sen' : (user.displayName ?? user.username),
              style: TextStyle(
                fontSize: 11,
                color:
                    user.isViewed ? tokens.textSecondary : tokens.textPrimary,
                fontWeight: user.isViewed ? FontWeight.normal : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _StorySkeleton extends StatelessWidget {
  const _StorySkeleton({required this.tokens});
  final MeropeColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 76,
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tokens.surfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: tokens.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
