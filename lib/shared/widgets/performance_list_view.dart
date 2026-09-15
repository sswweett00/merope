import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// PerformanceListView is optimized for rendering thousands of items
/// with zero jank by utilizing RepaintBoundaries and specific cache settings.
class PerformanceListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;

  const PerformanceListView({
    super.key,
    required this.children,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      controller: controller,
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          return RepaintBoundary(
            child: children[index],
          );
        },
        childCount: children.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
      ),
    );
  }
}

/// A specialized RenderObject widget for extremely heavy list items
class HighPerformanceItem extends SingleChildRenderObjectWidget {
  const HighPerformanceItem({super.key, required super.child});

  @override
  RenderHighPerformanceItem createRenderObject(BuildContext context) {
    return RenderHighPerformanceItem();
  }
}

class RenderHighPerformanceItem extends RenderProxyBox {
  @override
  bool get isRepaintBoundary => true; // Forces its own layer

  @override
  void paint(PaintingContext context, Offset offset) {
    // Custom painting logic can be added here for zero-allocation rendering
    super.paint(context, offset);
  }
}
