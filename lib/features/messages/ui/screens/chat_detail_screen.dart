import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:confetti/confetti.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../../data/providers/chat_provider.dart';
import '../../domain/models/message_model.dart';
import '../message_renderer.dart';
import 'package:merope_ui/widgets/reaction_picker.dart';
import '../widgets/media_picker_sheet.dart';
import '../widgets/sticker_picker_sheet.dart';
import '../widgets/animated_reaction_engine.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String title;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final text = _controller.text.trim();
      String? effect;
      if (text.toLowerCase().contains('tebrik') ||
          text.toLowerCase().contains('congrat')) {
        effect = 'confetti';
        _confettiController.play();
      }

      ref
          .read(chatMessagesProvider(widget.conversationId).notifier)
          .sendMessage(text, effect: effect);
      _controller.clear();
      HapticFeedback.lightImpact();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: MeropeTokens.durationNormal,
          curve: MeropeTokens.curveMeropeStandard,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final messagesAsync =
        ref.watch(chatMessagesProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: Stack(
        children: [
          Column(
            children: [
              _ChatAppBar(
                  title: widget.title,
                  tokens: tokens,
                  conversationId: widget.conversationId),
              Expanded(
                child: messagesAsync.when(
                  data: (messages) {
                    final grouped = _groupMessages(messages);
                    return CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      slivers: grouped.entries.map((entry) {
                        return SliverMainAxisGroup(
                          slivers: [
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _DateHeaderDelegate(
                                  date: entry.key, tokens: tokens),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: MeropeTokens.space20,
                                  vertical: MeropeTokens.space8),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final msg = entry.value[index];
                                    return _MessageBubble(
                                      msg: msg,
                                      isMe: msg.authorId == 'me',
                                      tokens: tokens,
                                      conversationId: widget.conversationId,
                                    );
                                  },
                                  childCount: entry.value.length,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ),
              _InputBar(
                controller: _controller,
                onSend: _sendMessage,
                tokens: tokens,
                onGifSelected: (gif) {
                  ref
                      .read(
                          chatMessagesProvider(widget.conversationId).notifier)
                      .sendGif(gif);
                  _scrollToBottom();
                },
                onStickerSelected: (sticker) {
                  ref
                      .read(
                          chatMessagesProvider(widget.conversationId).notifier)
                      .sendSticker(sticker);
                  _scrollToBottom();
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<MeropeMessage>> _groupMessages(
      List<MeropeMessage> messages) {
    final Map<String, List<MeropeMessage>> groups = {};
    for (var msg in messages) {
      final date = DateTime.fromMillisecondsSinceEpoch(msg.createdAt);
      final key = DateFormat('MMMM d, y').format(date);
      groups.putIfAbsent(key, () => []).add(msg);
    }
    return groups;
  }
}

class _ChatAppBar extends StatelessWidget {
  final String title;
  final String conversationId;
  final MeropeColorTokens tokens;

  const _ChatAppBar(
      {required this.title,
      required this.tokens,
      required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 8),
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: tokens.border, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: tokens.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const CircleAvatar(radius: 18, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("Çevrimiçi",
                        style: TextStyle(
                            color: tokens.onlineStatus, fontSize: 11)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4)),
                      child: const Text('TRUST: 98%',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.videocam_outlined, color: tokens.textSecondary),
            onPressed: () => context.push('/call/$conversationId/$title'),
          ),
          IconButton(
              icon: Icon(Icons.more_vert, color: tokens.textSecondary),
              onPressed: () {}),
        ],
      ),
    );
  }
}

class _DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String date;
  final MeropeColorTokens tokens;

  _DateHeaderDelegate({required this.date, required this.tokens});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: tokens.surfaceVariant.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
        ),
        child: Text(
          date,
          style: TextStyle(
              fontSize: 10,
              color: tokens.textSecondary,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 40;
  @override
  double get minExtent => 40;
  @override
  bool shouldRebuild(covariant _DateHeaderDelegate oldDelegate) =>
      oldDelegate.date != date;
}

class _MessageBubble extends ConsumerWidget {
  final MeropeMessage msg;
  final bool isMe;
  final MeropeColorTokens tokens;
  final String conversationId;

  const _MessageBubble({
    required this.msg,
    required this.isMe,
    required this.tokens,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPressStart: (details) =>
            _showMessageActions(context, details.globalPosition, ref),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: MeropeTokens.durationNormal,
              curve: MeropeTokens.curveMeropeStandard,
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.all(MeropeTokens.space12),
              decoration: BoxDecoration(
                color: (msg.blocks.isNotEmpty &&
                        msg.blocks.first.type == MessageBlockType.sticker)
                    ? Colors.transparent
                    : (isMe ? tokens.primary : tokens.surface),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(MeropeTokens.radiusLg),
                  topRight: const Radius.circular(MeropeTokens.radiusLg),
                  bottomLeft: Radius.circular(isMe ? MeropeTokens.radiusLg : 0),
                  bottomRight:
                      Radius.circular(isMe ? 0 : MeropeTokens.radiusLg),
                ),
                boxShadow: const [MeropeTokens.shadowSm],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MessageRenderer(
                      message: msg,
                      colors: isMe ? _getOnPrimaryTokens(tokens) : tokens,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  msg.createdAt)),
                          style: TextStyle(
                            fontSize: 9,
                            color:
                                (isMe ? tokens.onPrimary : tokens.textSecondary)
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 12,
                            color: tokens.onPrimary.withValues(alpha: 0.8),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (msg.reactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Wrap(
                  spacing: 4,
                  children: msg.reactions
                      .map<Widget>(
                        (r) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: tokens.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: tokens.primary.withValues(alpha: 0.2)),
                          ),
                          child: Text(r, style: const TextStyle(fontSize: 11)),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showMessageActions(BuildContext context, Offset position, WidgetRef r) {
    MeropeHaptics.trigger(MeropeTokens.hapticMedium);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReactionPicker(
            onReactionSelected: (emoji) {
              Navigator.pop(context);
              ReactionOverlayManager.showBurst(context, position, emoji);
              r
                  .read(chatMessagesProvider(conversationId).notifier)
                  .toggleReaction(msg.id, emoji);
            },
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(MeropeTokens.radiusLg)),
            ),
            child: Column(
              children: [
                ListTile(
                    leading: const Icon(Icons.reply_rounded),
                    title: const Text('Yanıtla'),
                    onTap: () => Navigator.pop(context)),
                if (isMe) ...[
                  ListTile(
                      leading: const Icon(Icons.edit_rounded),
                      title: const Text('Düzenle'),
                      onTap: () => Navigator.pop(context)),
                  ListTile(
                    leading:
                        const Icon(Icons.delete_rounded, color: Colors.red),
                    title:
                        const Text('Sil', style: TextStyle(color: Colors.red)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
                ListTile(
                    leading: const Icon(Icons.copy_rounded),
                    title: const Text('Kopyala'),
                    onTap: () => Navigator.pop(context)),
                ListTile(
                    leading: const Icon(Icons.push_pin_rounded),
                    title: const Text('Sabitle'),
                    onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MeropeColorTokens _getOnPrimaryTokens(MeropeColorTokens tokens) {
    return MeropeColorTokens(
      background: tokens.primary,
      surface: tokens.primary,
      surfaceVariant: tokens.primary,
      primary: tokens.onPrimary,
      primaryVariant: tokens.onPrimary.withValues(alpha: 0.8),
      onPrimary: tokens.primary,
      secondary: tokens.secondary,
      onSecondary: tokens.onSecondary,
      textPrimary: tokens.onPrimary,
      textSecondary: tokens.onPrimary.withValues(alpha: 0.7),
      border: tokens.onPrimary.withValues(alpha: 0.3),
      onlineStatus: tokens.onlineStatus,
      idleStatus: tokens.idleStatus,
      dndStatus: tokens.dndStatus,
      error: tokens.error,
      onError: tokens.onError,
      offlineStatus: tokens.offlineStatus,
      glassTint: tokens.glassTint,
      auraPrimary: tokens.onPrimary.withValues(alpha: 0.1),
      auraSecondary: tokens.secondary.withValues(alpha: 0.1),
      atmosphereDensity: tokens.atmosphereDensity,
    );
  }
}

class _InputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final MeropeColorTokens tokens;
  final Function(String gifUrl)? onGifSelected;
  final Function(String stickerUrl)? onStickerSelected;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.tokens,
    this.onGifSelected,
    this.onStickerSelected,
  });

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.tokens.surface,
            border: Border(
                top: BorderSide(color: widget.tokens.border, width: 0.5)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                _InputActionButton(
                  icon: Icons.add_rounded,
                  tokens: widget.tokens,
                  onTap: () => _showMediaPicker(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: widget.tokens.background,
                      borderRadius:
                          BorderRadius.circular(MeropeTokens.radiusXl),
                      border: Border.all(color: widget.tokens.border),
                    ),
                    child: Row(
                      children: [
                        _InputActionButton(
                          icon: _showEmoji
                              ? Icons.keyboard_rounded
                              : Icons.emoji_emotions_outlined,
                          tokens: widget.tokens,
                          onTap: () {
                            setState(() => _showEmoji = !_showEmoji);
                            if (_showEmoji) FocusScope.of(context).unfocus();
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            maxLines: 4,
                            minLines: 1,
                            onTap: () {
                              if (_showEmoji)
                                setState(() => _showEmoji = false);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Mesaj yazın...',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                            onSubmitted: (_) => widget.onSend(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.controller,
                  builder: (context, value, child) {
                    final isEmpty = value.text.trim().isEmpty;
                    return AnimatedSwitcher(
                      duration: MeropeTokens.durationFast,
                      child: isEmpty
                          ? _InputActionButton(
                              icon: Icons.mic_rounded,
                              tokens: widget.tokens,
                              onTap: () {})
                          : _InputActionButton(
                              icon: Icons.send_rounded,
                              tokens: widget.tokens,
                              onTap: widget.onSend,
                              isPrimary: true,
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (_showEmoji)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                widget.controller.text += emoji.emoji;
              },
              config: Config(
                indicatorColor: widget.tokens.primary,
                iconColorSelected: widget.tokens.primary,
                backspaceColor: widget.tokens.primary,
                skinToneDialogBgColor: widget.tokens.surface,
                skinToneIndicatorColor: widget.tokens.primary,
                enableSkinTones: true,
                recentTabBehavior: RecentTabBehavior.RECENT,
                recentsLimit: 28,
                noRecents: const Text('Henüz bir şey yok',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center),
                loadingIndicator: const SizedBox.shrink(),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          ),
      ],
    );
  }

  void _showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MediaPickerSheet(
        onCameraTap: () {},
        onGalleryTap: () {},
        onFileTap: () {},
        onLocationTap: () {},
        onGifTap: () => _showGifPicker(context),
        onStickerTap: () => _showStickerPicker(context),
      ),
    );
  }

  Future<void> _showGifPicker(BuildContext context) async {
    final gif = await GiphyGet.getGif(
      context: context,
      apiKey: "YOUR_GIPHY_API_KEY", // Should be configured
      lang: GiphyLanguage.turkish,
    );
    if (gif != null && gif.images?.original?.url != null) {
      widget.onGifSelected?.call(gif.images!.original!.url);
    }
  }

  void _showStickerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StickerPickerSheet(
        onStickerSelected: (url) {
          widget.onStickerSelected?.call(url);
        },
      ),
    );
  }
}

class _InputActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final MeropeColorTokens tokens;
  final bool isPrimary;

  const _InputActionButton({
    required this.icon,
    required this.onTap,
    required this.tokens,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary ? tokens.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isPrimary ? tokens.onPrimary : tokens.primary,
          size: 24,
        ),
      ),
    );
  }
}
