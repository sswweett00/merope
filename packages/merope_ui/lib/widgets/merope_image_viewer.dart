import 'package:flutter/material.dart';
import 'package:merope_ui/widgets/merope_image.dart';
import 'package:merope_ui/widgets/merope_glass_container.dart';

/// Fullscreen Interactive Image Viewer (Lightbox) for Merope.
class MeropeImageViewerModal extends StatefulWidget {
  final String? imageUrl;
  final String? assetPath;
  final Widget? imageWidget;
  final String? title;
  final String? subtitle;

  const MeropeImageViewerModal({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.imageWidget,
    this.title,
    this.subtitle,
  });

  static Future<void> show(
    BuildContext context, {
    String? imageUrl,
    String? assetPath,
    Widget? imageWidget,
    String? title,
    String? subtitle,
  }) {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black.withAlpha(230),
      builder: (_) => MeropeImageViewerModal(
        imageUrl: imageUrl,
        assetPath: assetPath,
        imageWidget: imageWidget,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  State<MeropeImageViewerModal> createState() => _MeropeImageViewerModalState();
}

class _MeropeImageViewerModalState extends State<MeropeImageViewerModal> {
  final TransformationController _transformationController = TransformationController();

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;
    if (widget.imageWidget != null) {
      content = widget.imageWidget!;
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      content = MeropeImage(
        imageUrl: widget.imageUrl!,
        fit: BoxFit.contain,
        enableViewer: false,
      );
    } else if (widget.assetPath != null && widget.assetPath!.isNotEmpty) {
      content = MeropeImage(
        assetPath: widget.assetPath!,
        fit: BoxFit.contain,
        enableViewer: false,
      );
    } else {
      content = const Icon(Icons.broken_image, size: 64, color: Colors.white54);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Interactive Pan & Zoom Area
          Center(
            child: GestureDetector(
              onDoubleTap: _resetZoom,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.8,
                maxScale: 4.0,
                child: content,
              ),
            ),
          ),

          // Top Header Bar
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 16,
            right: 16,
            child: MeropeGlassContainer(
              borderRadius: 24.0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null)
                          Text(
                            widget.title!,
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (widget.subtitle != null)
                          Text(
                            widget.subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.restart_alt, color: Colors.white70),
                    tooltip: 'Reset Zoom',
                    onPressed: _resetZoom,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
