import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merope_core/utils/view_preferences_provider.dart';

class DynamicLayoutEngine<T> extends StatelessWidget {
  final List<T> items;
  final ViewMode mode;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;

  const DynamicLayoutEngine({
    super.key,
    required this.items,
    required this.mode,
    required this.itemBuilder,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && !isLoadingMore) return const SizedBox.shrink();

    Widget content;
    switch (mode) {
      case ViewMode.grid:
        content = _buildGrid();
        break;
      case ViewMode.compact:
        content = _buildCompactList();
        break;
      case ViewMode.masonry:
        content = _buildMasonry();
        break;
      case ViewMode.carousel:
        content = _buildCarousel();
        break;
      case ViewMode.focus:
        content = _buildFocus();
        break;
      case ViewMode.list:
        content = _buildStandardList();
        break;
    }

    if (onLoadMore != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadingMore && hasMore && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            onLoadMore!();
          }
          return false;
        },
        child: content,
      );
    }

    return content;
  }

  Widget _buildStandardList() {
    return ListView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return itemBuilder(context, index, items[index]);
        }
        return const _LoadingMoreIndicator();
      },
    );
  }

  Widget _buildCompactList() {
    return ListView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return itemBuilder(context, index, items[index]);
        }
        return const _LoadingMoreIndicator();
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return itemBuilder(context, index, items[index]);
        }
        return const _LoadingMoreIndicator();
      },
    );
  }

  Widget _buildMasonry() {
    return MasonryGridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return itemBuilder(context, index, items[index]);
        }
        return const _LoadingMoreIndicator();
      },
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 400,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: itemBuilder(context, index, items[index]),
          );
        },
      ),
    );
  }

  Widget _buildFocus() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, index, items[index]),
    );
  }
}

class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
