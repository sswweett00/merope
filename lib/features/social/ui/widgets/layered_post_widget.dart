import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_models/social/post_model.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'package:merope_ui/widgets/merope_button.dart';

class LayeredPostWidget extends StatefulWidget {
  final MeropeSignal signal;
  final MeropeColorTokens tokens;

  const LayeredPostWidget({super.key, required this.signal, required this.tokens});

  @override
  State<LayeredPostWidget> createState() => _LayeredPostWidgetState();
}

class _LayeredPostWidgetState extends State<LayeredPostWidget> {
  int _currentLayerIndex = 0;

  void _nextLayer() {
    if (_currentLayerIndex < widget.signal.layers.length - 1) {
      setState(() => _currentLayerIndex++);
    }
  }

  void _prevLayer() {
    if (_currentLayerIndex > 0) {
      setState(() => _currentLayerIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.signal.layers.isEmpty) {
      return _buildSimplePost();
    }

    final layer = widget.signal.layers[_currentLayerIndex];

    return MeropeCard(
      color: widget.tokens.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      layer.title.toUpperCase(),
                      style: TextStyle(
                        color: widget.tokens.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'LAYER ${_currentLayerIndex + 1}/${widget.signal.layers.length}',
                      style: TextStyle(color: widget.tokens.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey(_currentLayerIndex),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          layer.content,
                          style: TextStyle(color: widget.tokens.textPrimary, fontSize: 15),
                        ),
                        if (layer.media.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          MeropeImage(
                            imageUrl: layer.media.first.url,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(12),
                            enableViewer: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_currentLayerIndex > 0)
                      IconButton(
                        onPressed: _prevLayer,
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        color: widget.tokens.primary,
                      ),
                    const Spacer(),
                    if (_currentLayerIndex < widget.signal.layers.length - 1)
                      MeropeButton(
                        text: 'Dive Deeper',
                        onPressed: _nextLayer,
                        style: MeropeButtonStyle.primary,
                      )
                    else
                      Text(
                        'End of Resonance',
                        style: TextStyle(color: widget.tokens.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(
        widget.signal.layers.length,
        (index) => Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: index <= _currentLayerIndex
                  ? widget.tokens.primary
                  : widget.tokens.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimplePost() {
    return Text(widget.signal.content, style: TextStyle(color: widget.tokens.textPrimary));
  }
}
