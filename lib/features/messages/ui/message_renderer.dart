import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../domain/models/message_model.dart';
import '../logic/e2ee_provider.dart';

class MessageRenderer extends ConsumerWidget {
  final MeropeMessage message;
  final MeropeColorTokens colors;

  const MessageRenderer({
    super.key,
    required this.message,
    required this.colors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content;

    if (message.metadata?['is_spark'] == true) {
      content = _SparkContainer(message: message, colors: colors);
    } else if (message.isEncrypted) {
      content = _EncryptedContainer(
        channelId: message.channelId,
        content: message.blocks.first.content,
        colors: colors,
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.blocks.map((block) => _buildBlock(block)).toList(),
      );
    }

    // Wrap in RepaintBoundary to isolate the message from other list items
    return RepaintBoundary(child: content);
  }

  Widget _buildBlock(MessageBlock block) {
    switch (block.type) {
      case MessageBlockType.header:
        return Padding(
          padding: const EdgeInsets.only(bottom: MeropeTokens.space8),
          child: Text(
            block.content,
            style: TextStyle(
              fontSize: MeropeTokens.fontSizeLg,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              height: MeropeTokens.fontHeightTight,
            ),
          ),
        );
      case MessageBlockType.text:
      case MessageBlockType.markdown:
        return Padding(
          padding: const EdgeInsets.only(bottom: MeropeTokens.space4),
          child: Text(
            block.content,
            style: TextStyle(
              fontSize: MeropeTokens.fontSizeMd,
              color: colors.textPrimary,
              height: MeropeTokens.fontHeightNormal,
            ),
          ),
        );
      case MessageBlockType.image:
        return _ImageBlock(
            url: block.metadata?['url'] ?? block.content, tokens: colors);
      case MessageBlockType.gif:
        return _GifBlock(
            url: block.metadata?['url'] ?? block.content, tokens: colors);
      case MessageBlockType.sticker:
        return _StickerBlock(url: block.metadata?['url'] ?? block.content);
      case MessageBlockType.video:
        return _VideoBlock(
            url: block.metadata?['url'] ?? block.content, tokens: colors);
      case MessageBlockType.audio:
        return _AudioBlock(
            url: block.metadata?['url'] ?? block.content, tokens: colors);
      case MessageBlockType.code:
        return _CodeBlock(content: block.content, colors: colors);
      case MessageBlockType.quote:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: MeropeTokens.space4),
          padding: const EdgeInsets.only(left: MeropeTokens.space12),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: colors.primary, width: 4)),
          ),
          child: Text(
            block.content,
            style: TextStyle(
              fontSize: MeropeTokens.fontSizeMd,
              color: colors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _EncryptedContainer extends ConsumerWidget {
  final String channelId;
  final String content;
  final MeropeColorTokens colors;

  const _EncryptedContainer(
      {required this.channelId, required this.content, required this.colors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      // ignore: discarded_futures
      future: ref
          .read(e2EEControllerProvider.notifier)
          .decryptMessage(channelId, content),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(child: _EncryptionPulse(color: colors.primary)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  snapshot.data!,
                  style: TextStyle(
                      fontSize: MeropeTokens.fontSizeMd,
                      color: colors.textPrimary),
                ),
              ),
            ],
          );
        }
        return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }
}

class _SparkContainer extends StatefulWidget {
  final MeropeMessage message;
  final MeropeColorTokens colors;

  const _SparkContainer({required this.message, required this.colors});

  @override
  State<_SparkContainer> createState() => _SparkContainerState();
}

class _SparkContainerState extends State<_SparkContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shredController;
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _shredController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    final expiresAt = widget.message.metadata?['expires_at'] as int?;
    if (expiresAt != null) {
      _remainingSeconds =
          (expiresAt - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
      _startTimer();
    } else {
      _remainingSeconds = 0;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _shredController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _shredController,
        builder: (context, child) {
          if (_shredController.value == 1.0) return const SizedBox.shrink();

          return Opacity(
            opacity: 1.0 - _shredController.value,
            child: Transform.translate(
              offset: Offset(0, 20 * _shredController.value),
              child: Container(
                padding: const EdgeInsets.all(MeropeTokens.space12),
                decoration: BoxDecoration(
                  color: widget.colors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
                  border: Border.all(
                      color: widget.colors.error.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_fire_department_rounded,
                            size: 16, color: widget.colors.error),
                        const SizedBox(width: 8),
                        Text(
                          'SPARK - Expiring in ${_remainingSeconds}s',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: widget.colors.error),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.message.blocks.first.content,
                      style: TextStyle(color: widget.colors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EncryptionPulse extends StatefulWidget {
  final Color color;
  const _EncryptionPulse({required this.color});

  @override
  State<_EncryptionPulse> createState() => _EncryptionPulseState();
}

class _EncryptionPulseState extends State<_EncryptionPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
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
      builder: (context, child) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              widget.color.withValues(alpha: 0.3 + (_controller.value * 0.7)),
          boxShadow: [
            BoxShadow(
                color: widget.color.withValues(alpha: _controller.value * 0.5),
                blurRadius: 8 * _controller.value),
          ],
        ),
      ),
    );
  }
}

class _ImageBlock extends StatelessWidget {
  final String url;
  final MeropeColorTokens tokens;
  const _ImageBlock({required this.url, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: MeropeTokens.space8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          border: Border.all(color: tokens.border.withValues(alpha: 0.5)),
        ),
        child: MeropeImage(
          imageUrl: url,
          fit: BoxFit.cover,
          enableViewer: true,
        ),
      ),
    );
  }
}

class _VideoBlock extends StatelessWidget {
  final String url;
  final MeropeColorTokens tokens;
  const _VideoBlock({required this.url, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: MeropeTokens.space8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          color: Colors.black87,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(color: tokens.surfaceVariant)),
            const Icon(Icons.play_circle_fill, size: 48, color: Colors.white70),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4)),
                child: const Text("0:45",
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioBlock extends StatefulWidget {
  final String url;
  final MeropeColorTokens tokens;
  const _AudioBlock({required this.url, required this.tokens});

  @override
  State<_AudioBlock> createState() => _AudioBlockState();
}

class _AudioBlockState extends State<_AudioBlock> {
  bool _isTranscribing = false;
  String? _transcription;

  void _toggleTranscription() async {
    if (!mounted) return;
    setState(() => _isTranscribing = true);
    // Simulate Edge-based STT
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _transcription =
          "This is a high-performance voice message handled on-device for maximum privacy.";
      _isTranscribing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: MeropeTokens.space8),
            padding: const EdgeInsets.all(MeropeTokens.space12),
            decoration: BoxDecoration(
              color: widget.tokens.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: widget.tokens.primary, shape: BoxShape.circle),
                  child:
                      const Icon(Icons.play_arrow_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomPaint(
                    size: const Size(double.infinity, 32),
                    painter: _WaveformPainter(color: widget.tokens.primary),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _toggleTranscription,
                  child: Icon(
                    _transcription != null
                        ? Icons.closed_caption_rounded
                        : Icons.closed_caption_disabled_rounded,
                    color: widget.tokens.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          if (_isTranscribing)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: widget.tokens.textSecondary),
              ),
            ),
          if (_transcription != null)
            Container(
              margin: const EdgeInsets.only(left: 4, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.tokens.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
                border: Border.all(
                    color: widget.tokens.border.withValues(alpha: 0.3)),
              ),
              child: Text(
                _transcription!,
                style: TextStyle(
                    fontSize: MeropeTokens.fontSizeSm,
                    color: widget.tokens.textSecondary,
                    fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Color color;
  _WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    for (var i = 0; i < size.width; i += 4) {
      final height = 4 + (i % 12).toDouble() + (i % 7).toDouble();
      canvas.drawLine(Offset(i.toDouble(), size.height / 2 - height / 2),
          Offset(i.toDouble(), size.height / 2 + height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CodeBlock extends StatelessWidget {
  final String content;
  final MeropeColorTokens colors;
  const _CodeBlock({required this.content, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: MeropeTokens.space8),
      padding: const EdgeInsets.all(MeropeTokens.space12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("KOD",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colors.textSecondary.withValues(alpha: 0.5))),
              Icon(Icons.copy_rounded, size: 14, color: colors.textSecondary),
            ],
          ),
          const Divider(height: 12),
          Text(
            content,
            style: const TextStyle(
                fontFamily: 'monospace', fontSize: MeropeTokens.fontSizeSm),
          ),
        ],
      ),
    );
  }
}

class _GifBlock extends StatelessWidget {
  final String url;
  final MeropeColorTokens tokens;
  const _GifBlock({required this.url, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: MeropeTokens.space8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        ),
        child: MeropeImage(
          imageUrl: url,
          fit: BoxFit.cover,
          enableViewer: true,
        ),
      ),
    );
  }
}

class _StickerBlock extends StatelessWidget {
  final String url;
  const _StickerBlock({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 160, maxHeight: 160),
      child: MeropeImage(
        imageUrl: url,
        fit: BoxFit.contain,
        enableViewer: true,
      ),
    );
  }
}
