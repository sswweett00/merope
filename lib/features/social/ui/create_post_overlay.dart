import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../logic/timeline_provider.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import 'package:merope_core/utils/merope_acoustics.dart';
import 'package:merope_models/social/post_model.dart';

class CreatePostOverlay extends ConsumerStatefulWidget {
  const CreatePostOverlay({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Create Post',
      pageBuilder: (context, anim1, anim2) => const CreatePostOverlay(),
      transitionDuration: MeropeTokens.durationNormal,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim1),
            child: child,
          ),
        );
      },
    );
  }

  @override
  ConsumerState<CreatePostOverlay> createState() => _CreatePostOverlayState();
}

class _CreatePostOverlayState extends ConsumerState<CreatePostOverlay> {
  final _controller = TextEditingController();
  bool _isPollMode = false;
  String _burnOption = 'Never';
  final List<TextEditingController> _pollOptions = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool _isRecording = false;
  bool _isAIStudioOpen = false;
  String? _selectedAIVision;

  @override
  void dispose() {
    _controller.dispose();
    for (var c in _pollOptions) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isNotEmpty ||
        _isRecording ||
        _selectedAIVision != null) {
      if (_isPollMode) {
        final options = _pollOptions
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        ref.read(nexusTimelineProvider.notifier).broadcastSignal(
              _controller.text.trim(),
              pollQuestion: 'Poll',
              pollOptions: options,
            );
      } else {
        final List<SignalMedia> media = [];
        if (_isRecording)
          media.add(const SignalMedia(
              url: 'audio_wave_placeholder', type: MediaType.audio));
        if (_selectedAIVision != null)
          media
              .add(SignalMedia(url: _selectedAIVision!, type: MediaType.image));

        ref.read(nexusTimelineProvider.notifier).broadcastSignal(
              _controller.text.trim(),
              media: media,
            );
      }
      MeropeHaptics.neuralSyncPulse();
      MeropeAcoustics.trigger(AcousticEffect.syncSuccess);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: MeropeGlassContainer(
          width: 600,
          padding: const EdgeInsets.all(MeropeTokens.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isAIStudioOpen ? 'AI Prism Studio' : 'New Post',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tokens.textPrimary,
                        ),
                      ),
                      Text(
                          _isAIStudioOpen
                              ? 'Generating high-resonance visions'
                              : 'Draft Saved Locally',
                          style:
                              TextStyle(fontSize: 10, color: tokens.primary)),
                    ],
                  ),
                  IconButton(
                    icon: Icon(_isAIStudioOpen ? Icons.arrow_back : Icons.close,
                        color: tokens.textSecondary),
                    onPressed: () {
                      if (_isAIStudioOpen) {
                        setState(() => _isAIStudioOpen = false);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_isAIStudioOpen)
                _buildAIStudioBody(tokens)
              else
                _buildDefaultBody(tokens),
              const SizedBox(height: MeropeTokens.space24),
              if (!_isAIStudioOpen)
                Row(
                  children: [
                    _ToolButton(
                      icon: _selectedAIVision != null
                          ? Icons.auto_awesome
                          : Icons.image_outlined,
                      label: 'Media',
                      tokens: tokens,
                    ),
                    _ToolButton(
                      icon: _isRecording ? Icons.mic : Icons.mic_none,
                      label: 'Voice Wave',
                      tokens: tokens,
                      onPressed: () {
                        setState(() => _isRecording = !_isRecording);
                        if (_isRecording)
                          MeropeHaptics.trigger(MeropeTokens.hapticLight);
                      },
                    ),
                    _ToolButton(
                      icon: Icons.auto_awesome_outlined,
                      label: 'AI Studio',
                      tokens: tokens,
                      onPressed: () => setState(() => _isAIStudioOpen = true),
                    ),
                    _ToolButton(
                      icon: Icons.local_fire_department_outlined,
                      label: 'Burn: $_burnOption',
                      tokens: tokens,
                      onPressed: () {
                        setState(() {
                          if (_burnOption == 'Never') {
                            _burnOption = '24h';
                          } else if (_burnOption == '24h') {
                            _burnOption = '1w';
                          } else {
                            _burnOption = 'Never';
                          }
                        });
                      },
                    ),
                    _ToolButton(
                      icon: _isPollMode ? Icons.poll : Icons.poll_outlined,
                      label: 'Poll',
                      tokens: tokens,
                      onPressed: () =>
                          setState(() => _isPollMode = !_isPollMode),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(MeropeTokens.radiusMd)),
                      ),
                      child: const Text('Post'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultBody(MeropeColorTokens tokens) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: tokens.primary.withValues(alpha: 0.2),
          child: const Icon(Icons.person,
              color: Colors.blue), // Fixed color for demo
        ),
        const SizedBox(width: MeropeTokens.space16),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLines: _isPollMode ? 2 : 5,
                autofocus: true,
                style: TextStyle(color: tokens.textPrimary, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(
                      color: tokens.textSecondary.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                ),
              ),
              if (_isRecording)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: tokens.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.mic, color: Colors.red, size: 16),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              20,
                              (i) => Container(
                                    width: 2,
                                    height: 10.0 + (i % 7) * 4,
                                    color: tokens.primary,
                                  )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('0:04',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              if (_selectedAIVision != null)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: 120,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: MeropeImage(
                          imageUrl: _selectedAIVision!,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(12),
                          enableViewer: true,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () =>
                              setState(() => _selectedAIVision = null),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isPollMode) ...[
                const SizedBox(height: 16),
                ..._pollOptions.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: entry.value,
                        style:
                            TextStyle(color: tokens.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Option ${entry.key + 1}',
                          filled: true,
                          fillColor: tokens.surface,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    )),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _pollOptions.add(TextEditingController())),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Option'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIStudioBody(MeropeColorTokens tokens) {
    final visions = [
      'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1964',
      'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=1974',
      'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?q=80&w=1935',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select a Neural Vision:',
            style: TextStyle(color: tokens.textSecondary, fontSize: 13)),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: visions.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                MeropeHaptics.trigger(MeropeTokens.hapticMedium);
                setState(() {
                  _selectedAIVision = visions[index];
                  _isAIStudioOpen = false;
                });
              },
              child: Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                child: MeropeImage(
                  imageUrl: visions[index],
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: () => MeropeAcoustics.trigger(AcousticEffect.resonance),
            icon: const Icon(Icons.refresh),
            label: const Text('Re-generate Core'),
          ),
        ),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final MeropeColorTokens tokens;
  final VoidCallback? onPressed;

  const _ToolButton(
      {this.icon, required this.label, required this.tokens, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: IconButton(
        icon: Icon(icon ?? Icons.circle, color: tokens.primary, size: 22),
        tooltip: label,
        onPressed: onPressed ?? () {},
      ),
    );
  }
}
