import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Wrapper for staggered list animations.
/// Wraps a ListView or Column to animate children with a staggered effect.
class StaggeredListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int durationMs;
  final double verticalOffset;
  final double horizontalOffset;

  const StaggeredListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.durationMs = 400,
    this.verticalOffset = 50.0,
    this.horizontalOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemCount: children.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: durationMs),
            child: SlideAnimation(
              verticalOffset: verticalOffset,
              horizontalOffset: horizontalOffset,
              child: FadeInAnimation(
                child: children[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Wrapper for staggered grid animations.
class StaggeredGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int durationMs;

  const StaggeredGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.durationMs = 400,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: crossAxisCount,
            duration: Duration(milliseconds: durationMs),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: children[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Single staggered animation item wrapper.
/// Use when you need to animate individual items with an index.
class StaggeredItem extends StatelessWidget {
  final Widget child;
  final int index;
  final int durationMs;
  final double verticalOffset;
  final AnimationType type;

  const StaggeredItem({
    super.key,
    required this.child,
    required this.index,
    this.durationMs = 400,
    this.verticalOffset = 50.0,
    this.type = AnimationType.slideUp,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: Duration(milliseconds: durationMs),
      child: _buildAnimation(),
    );
  }

  Widget _buildAnimation() {
    switch (type) {
      case AnimationType.slideUp:
        return SlideAnimation(
          verticalOffset: verticalOffset,
          child: FadeInAnimation(child: child),
        );
      case AnimationType.slideRight:
        return SlideAnimation(
          horizontalOffset: -50.0,
          child: FadeInAnimation(child: child),
        );
      case AnimationType.scale:
        return ScaleAnimation(
          child: FadeInAnimation(child: child),
        );
      case AnimationType.flip:
        return FlipAnimation(
          child: FadeInAnimation(child: child),
        );
    }
  }
}

enum AnimationType {
  slideUp,
  slideRight,
  scale,
  flip,
}

/// Animated sliver list for CustomScrollView.
class AnimatedSliverList extends StatelessWidget {
  final List<Widget> children;
  final int durationMs;
  final double verticalOffset;

  const AnimatedSliverList({
    super.key,
    required this.children,
    this.durationMs = 400,
    this.verticalOffset = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: durationMs),
            child: SlideAnimation(
              verticalOffset: verticalOffset,
              child: FadeInAnimation(
                child: children[index],
              ),
            ),
          );
        },
        childCount: children.length,
      ),
    );
  }
}

/// Extension to easily wrap any widget with staggered animation.
extension StaggeredAnimationExtension on Widget {
  Widget staggered(int index, {int durationMs = 400, double offset = 50.0}) {
    return StaggeredItem(
      index: index,
      durationMs: durationMs,
      verticalOffset: offset,
      child: this,
    );
  }
}
