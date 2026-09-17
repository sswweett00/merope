import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:merope_core/media/image_cache_manager.dart';
import 'package:merope_ui/widgets/merope_image_viewer.dart';

/// High-Performance Image Rendering Widget for Merope.
/// Optimized for zero-lag lists, memory safety, caching, shimmer loading, and error handling.
/// Integrates BlurHash for professional-grade placeholder experience.
class MeropeImage extends StatefulWidget {
  final String? imageUrl;
  final String? assetPath;
  final File? file;
  final Uint8List? bytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final bool enableViewer;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Map<String, String>? headers;

  /// Professional feature: BlurHash string to show while the high-res image is loading.
  final String? blurHash;

  const MeropeImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.file,
    this.bytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
    this.enableViewer = false,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 200),
    this.headers,
    this.blurHash,
  });

  /// Factory for Avatar images with custom dimensions and circular clip.
  factory MeropeImage.avatar({
    Key? key,
    required String? imageUrl,
    double radius = 24.0,
    String? initials,
    bool enableViewer = false,
    String? blurHash,
  }) {
    final size = radius * 2;
    return MeropeImage(
      key: key,
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(radius),
      fit: BoxFit.cover,
      enableViewer: enableViewer,
      memCacheWidth: (size * 2).toInt(),
      memCacheHeight: (size * 2).toInt(),
      blurHash: blurHash,
      errorWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade800,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          (initials != null && initials.isNotEmpty)
              ? initials.substring(0, 1).toUpperCase()
              : '?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.8,
          ),
        ),
      ),
    );
  }

  @override
  State<MeropeImage> createState() => _MeropeImageState();
}

class _MeropeImageState extends State<MeropeImage> {
  Uint8List? _cachedBytes;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant MeropeImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.file != widget.file ||
        oldWidget.assetPath != widget.assetPath ||
        oldWidget.bytes != widget.bytes) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (widget.bytes != null) {
      if (mounted) {
        setState(() {
          _cachedBytes = widget.bytes;
          _isLoading = false;
          _hasError = false;
        });
      }
      return;
    }

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
      }

      final bytes = await MeropeImageCacheManager().getImageBytes(
        widget.imageUrl!,
        headers: widget.headers,
      );

      if (!mounted) return;

      if (bytes != null) {
        setState(() {
          _cachedBytes = bytes;
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  int? _resolveMemCacheWidth(BuildContext context) {
    if (widget.memCacheWidth != null) return widget.memCacheWidth;
    if (widget.width != null && widget.width! > 0) {
      final ratio = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
      return (widget.width! * ratio).toInt();
    }
    return null;
  }

  int? _resolveMemCacheHeight(BuildContext context) {
    if (widget.memCacheHeight != null) return widget.memCacheHeight;
    if (widget.height != null && widget.height! > 0) {
      final ratio = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
      return (widget.height! * ratio).toInt();
    }
    return null;
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (widget.placeholder != null) return widget.placeholder!;

    // Professional: Use BlurHash if available, else fallback to Shimmer
    if (widget.blurHash != null && widget.blurHash!.length >= 6) {
      return BlurHash(
        hash: widget.blurHash!,
        imageFit: widget.fit,
      );
    }

    return _MeropeShimmerBox(
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (widget.errorWidget != null) return widget.errorWidget!;

    return Container(
      width: widget.width,
      height: widget.height,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.broken_image_outlined,
                size: 28, color: Colors.grey),
            if (widget.imageUrl != null)
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: _loadImage,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_hasError) {
      imageWidget = _buildErrorWidget(context);
    } else if (_isLoading && _cachedBytes == null && widget.imageUrl != null) {
      imageWidget = _buildPlaceholder(context);
    } else if (_cachedBytes != null) {
      imageWidget = Image.memory(
        _cachedBytes!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        cacheWidth: _resolveMemCacheWidth(context),
        cacheHeight: _resolveMemCacheHeight(context),
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;

          // Stack the image on top of the placeholder (BlurHash) during fade-in
          if (frame == null) return _buildPlaceholder(context);

          return AnimatedOpacity(
            opacity: 1.0,
            duration: widget.fadeInDuration,
            curve: Curves.easeOut,
            child: child,
          );
        },
      );
    } else if (widget.file != null) {
      imageWidget = Image.file(
        widget.file!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        cacheWidth: _resolveMemCacheWidth(context),
        cacheHeight: _resolveMemCacheHeight(context),
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
      );
    } else if (widget.assetPath != null && widget.assetPath!.isNotEmpty) {
      imageWidget = Image.asset(
        widget.assetPath!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        cacheWidth: _resolveMemCacheWidth(context),
        cacheHeight: _resolveMemCacheHeight(context),
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
      );
    } else {
      imageWidget = _buildErrorWidget(context);
    }

    if (widget.borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    if (widget.enableViewer && !_hasError) {
      imageWidget = GestureDetector(
        onTap: () {
          MeropeImageViewerModal.show(
            context,
            imageUrl: widget.imageUrl,
            assetPath: widget.assetPath,
            imageWidget:
                _cachedBytes != null ? Image.memory(_cachedBytes!) : null,
          );
        },
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Shimmer Skeleton Box for Loading States.
class _MeropeShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const _MeropeShimmerBox({this.width, this.height, this.borderRadius});

  @override
  State<_MeropeShimmerBox> createState() => _MeropeShimmerBoxState();
}

class _MeropeShimmerBoxState extends State<_MeropeShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade900 : Colors.grey.shade300;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: _animation.value),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
