import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/tokens/merope_tokens.dart';
import '../theme/theme_provider.dart';
import 'hud_provider.dart';

class HUDOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const HUDOverlay({super.key, required this.child});

  @override
  ConsumerState<HUDOverlay> createState() => _HUDOverlayState();
}

class _HUDOverlayState extends ConsumerState<HUDOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MeropeTokens.durationNormal,
    );
    _fadeAnimation = CurvedAnimation(
        parent: _controller, curve: MeropeTokens.curveMeropeEntrance);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: MeropeTokens.curveMeropeEntrance),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      final isControl = HardwareKeyboard.instance.isControlPressed ||
          HardwareKeyboard.instance.isMetaPressed;
      if (isControl && event.logicalKey == LogicalKeyboardKey.keyK) {
        ref.read(hUDControllerProvider.notifier).toggle();
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        ref.read(hUDControllerProvider.notifier).hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(hUDControllerProvider);
    final tokens = ref.watch(themeProvider).currentTokens;

    if (isOpen) {
      _controller.forward();
      _focusNode.requestFocus();
    } else {
      _controller.reverse();
      _focusNode.unfocus();
      _textController.clear();
    }

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKey,
      child: Stack(
        children: [
          widget.child,
          if (isOpen)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            ref.read(hUDControllerProvider.notifier).hide(),
                        child: Container(
                          color: Colors.black
                              .withValues(alpha: 0.4 * _fadeAnimation.value),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: MeropeTokens.blurMedium *
                                  _fadeAnimation.value,
                              sigmaY: MeropeTokens.blurMedium *
                                  _fadeAnimation.value,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                      Center(
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 600,
                            height: 400,
                            margin: const EdgeInsets.all(MeropeTokens.space24),
                            decoration: BoxDecoration(
                              color: tokens.surface.withValues(alpha: 0.8),
                              borderRadius:
                                  BorderRadius.circular(MeropeTokens.radiusLg),
                              border: Border.all(
                                  color: tokens.border.withValues(alpha: 0.5)),
                              boxShadow: [MeropeTokens.shadowLg],
                            ),
                            child: Column(
                              children: [
                                _buildSearchInput(tokens),
                                const Divider(height: 1),
                                Expanded(child: _buildActionList(tokens)),
                                _buildFooter(tokens),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchInput(MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: tokens.textSecondary),
          const SizedBox(width: MeropeTokens.space12),
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              onChanged: (val) =>
                  ref.read(hUDSearchProvider.notifier).update(val),
              style: TextStyle(
                  color: tokens.textPrimary, fontSize: MeropeTokens.fontSizeMd),
              decoration: InputDecoration(
                hintText: 'Search commands or features...',
                hintStyle: TextStyle(
                    color: tokens.textSecondary.withValues(alpha: 0.5)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: tokens.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: tokens.border),
            ),
            child: Text('ESC',
                style: TextStyle(fontSize: 10, color: tokens.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionList(MeropeColorTokens tokens) {
    final actions = ref.watch(filteredHUDActionsProvider);
    final query = ref.watch(hUDSearchProvider);

    if (actions.isEmpty) {
      return Center(
        child: Text('No matching commands',
            style: TextStyle(color: tokens.textSecondary)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: MeropeTokens.space8),
      itemCount: actions.length + (query.isEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (query.isEmpty && index == 0) {
          return _buildNeuralSuggestions(tokens);
        }

        final action = actions[query.isEmpty ? index - 1 : index];
        return ListTile(
          onTap: () {
            action.onExecute();
            ref.read(hUDControllerProvider.notifier).hide();
          },
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tokens.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.flash_on_rounded, size: 18, color: tokens.primary),
          ),
          title: Text(action.label,
              style: TextStyle(
                  color: tokens.textPrimary, fontWeight: FontWeight.bold)),
          subtitle: Text(action.description,
              style: TextStyle(
                  color: tokens.textSecondary,
                  fontSize: MeropeTokens.fontSizeSm)),
          trailing: Text(action.category ?? '',
              style: TextStyle(
                  color: tokens.textSecondary.withValues(alpha: 0.5),
                  fontSize: 10)),
        );
      },
    );
  }

  Widget _buildNeuralSuggestions(MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  size: 14, color: tokens.secondary),
              const SizedBox(width: 8),
              Text(
                'NEURAL SUGGESTIONS',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: tokens.textSecondary,
                    letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _SuggestionChip(label: 'Sync Corporate Vault', tokens: tokens),
                _SuggestionChip(label: 'New Secret Spark', tokens: tokens),
                _SuggestionChip(label: 'Check Risk Profile', tokens: tokens),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildFooter(MeropeColorTokens tokens) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: MeropeTokens.space16, vertical: MeropeTokens.space12),
      decoration: BoxDecoration(
        color: tokens.background.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(MeropeTokens.radiusLg),
          bottomRight: Radius.circular(MeropeTokens.radiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildShortcutHint('↑↓', 'Navigate', tokens),
              const SizedBox(width: 16),
              _buildShortcutHint('↵', 'Execute', tokens),
            ],
          ),
          Text('Merope Nerve Center v1.0',
              style: TextStyle(
                  fontSize: 10,
                  color: tokens.textSecondary.withValues(alpha: 0.3))),
        ],
      ),
    );
  }

  Widget _buildShortcutHint(
      String key, String label, MeropeColorTokens tokens) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: tokens.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(key,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: tokens.textSecondary)),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 10, color: tokens.textSecondary)),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final MeropeColorTokens tokens;
  const _SuggestionChip({required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.2)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              color: tokens.primary,
              fontWeight: FontWeight.w500)),
    );
  }
}
