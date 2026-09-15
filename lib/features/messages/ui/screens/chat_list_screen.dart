import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/presence_indicator.dart';
import '../../data/providers/chat_provider.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final chatListAsync = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _Header(tokens: tokens),
          Expanded(
            child: chatListAsync.when(
              data: (conversations) => ListView.builder(
                padding: const EdgeInsets.all(MeropeTokens.space24),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  return _ConversationTile(conv: conv, tokens: tokens);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Comm Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _Header({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Messages',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_note, color: tokens.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final dynamic conv;
  final MeropeColorTokens tokens;

  const _ConversationTile({required this.conv, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: MeropeTokens.space12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(conversationId: conv.id, title: conv.title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(MeropeTokens.space16),
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _Avatar(tokens: tokens, avatarUrl: conv.avatarUrl, name: conv.title),
                  PresenceIndicator(status: PresenceStatus.online, tokens: tokens),
                ],
              ),
              const SizedBox(width: MeropeTokens.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conv.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _NeuralStatusRow(conv: conv, tokens: tokens),
                  ],
                ),
              ),
              if (conv.unreadCount > 0)
// ... existing unread badge ...
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: tokens.primary, shape: BoxShape.circle),
                  child: Text(
                    '${conv.unreadCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeuralStatusRow extends StatelessWidget {
  final dynamic conv;
  final MeropeColorTokens tokens;
  const _NeuralStatusRow({required this.conv, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final isTyping = conv.title.length % 2 == 0; // Simulation logic

    if (isTyping) {
      return Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: tokens.primary),
          ),
          const SizedBox(width: 8),
          Text(
            'Typing...',
            style: TextStyle(color: tokens.primary, fontSize: 13, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
        ],
      );
    }

    return Text(
      conv.lastMessage ?? 'No signals yet.',
      style: TextStyle(
        color: tokens.textSecondary,
        fontSize: 14,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Avatar extends StatelessWidget {
  final MeropeColorTokens tokens;
  final String? avatarUrl;
  final String name;

  const _Avatar({required this.tokens, this.avatarUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return MeropeImage.avatar(
      imageUrl: avatarUrl,
      radius: 24,
      initials: name,
    );
  }
}
