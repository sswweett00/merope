import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class MultiStreamScreen extends ConsumerStatefulWidget {
  final String roomId;
  const MultiStreamScreen({super.key, required this.roomId});

  @override
  ConsumerState<MultiStreamScreen> createState() => _MultiStreamScreenState();
}

class _MultiStreamScreenState extends ConsumerState<MultiStreamScreen> {
  int _streamerCount = 4;
  String _layout = 'grid'; // grid, pip, focus
  bool _showChat = false;

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildStreamLayout(),
          if (_showChat) _buildSideChat(tokens),
          _buildHeader(tokens),
          _buildFooter(tokens),
          const _ReactionOverlay(),
        ],
      ),
    );
  }

  Widget _buildSideChat(MeropeColorTokens tokens) {
    return Positioned(
      top: 120,
      bottom: 120,
      right: 0,
      width: 260,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
          border: Border(left: BorderSide(color: tokens.border, width: 0.5)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('LIVE CHAT',
                  style: TextStyle(
                      color: tokens.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
            const Expanded(child: _ChatThread()),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamLayout() {
    switch (_layout) {
      case 'grid':
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _streamerCount > 2 ? 2 : 1,
            childAspectRatio: _streamerCount > 2 ? 0.8 : 1.7,
          ),
          itemCount: _streamerCount,
          itemBuilder: (context, index) => _StreamView(index: index),
        );
      case 'focus':
        return Column(
          children: [
            const Expanded(flex: 3, child: _StreamView(index: 0)),
            Expanded(
              flex: 1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _streamerCount - 1,
                itemBuilder: (context, index) => SizedBox(
                  width: 150,
                  child: _StreamView(index: index + 1),
                ),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildHeader(MeropeColorTokens tokens) {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: const Text('LIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Text(
            'Resonance Room #${widget.roomId}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(MeropeColorTokens tokens) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CircleAction(
              icon: Icons.chat_bubble_outline,
              onTap: () => setState(() => _showChat = !_showChat)),
          _CircleAction(
              icon: Icons.grid_view,
              onTap: () => setState(() => _layout = 'grid')),
          _CircleAction(
              icon: Icons.person_pin,
              onTap: () => setState(() => _layout = 'focus')),
          _CircleAction(
            icon: Icons.add,
            color: tokens.primary,
            onTap: () =>
                setState(() => _streamerCount = (_streamerCount % 12) + 1),
          ),
          const _CircleAction(icon: Icons.mic, color: Colors.white24),
          const _CircleAction(icon: Icons.videocam, color: Colors.white24),
        ],
      ),
    );
  }
}

class _ChatThread extends StatelessWidget {
  const _ChatThread();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 20,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12),
            children: [
              TextSpan(
                  text: 'User$index: ',
                  style: const TextStyle(
                      color: Colors.white54, fontWeight: FontWeight.bold)),
              const TextSpan(
                  text: 'Sending neural waves to this channel! ⚡️',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReactionOverlay extends StatelessWidget {
  const _ReactionOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(5, (i) => _ReactionItem(index: i)),
      ),
    );
  }
}

class _ReactionItem extends StatefulWidget {
  final int index;
  const _ReactionItem({required this.index});

  @override
  State<_ReactionItem> createState() => _ReactionItemState();
}

class _ReactionItemState extends State<_ReactionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final val = _controller.value;
        return Positioned(
          bottom: 100 + (val * 400),
          right: 20 + (widget.index * 40.0),
          child: Opacity(
            opacity: (1.0 - val).clamp(0.0, 1.0),
            child: Text(['⚡️', '❤️', '🔥', '💎', '💠'][widget.index % 5],
                style: const TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
}

class _StreamView extends StatelessWidget {
  final int index;
  const _StreamView({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      child: Stack(
        children: [
          const Center(
              child: Icon(Icons.person, color: Colors.white12, size: 64)),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4)),
              child: Text('Streamer #$index',
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _CircleAction(
      {required this.icon, this.onTap, this.color = Colors.black45});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
