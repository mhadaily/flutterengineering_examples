import 'package:flutter/material.dart';

enum ScreenSize {
  // Phone in portrait
  compact(maxWidth: 600),
  // Tablet in portrait or Foldable in portrait (unfolded)
  medium(maxWidth: 840),
  // Phone in landscape or Tablet in landscape or
  // Foldable in landscape (unfolded) or Desktop
  expanded(maxWidth: 1200),
  // Desktop
  large(maxWidth: 1600);

  const ScreenSize({required this.maxWidth});

  final double maxWidth;

  bool isSmallerThan(double screenWidth) => screenWidth < maxWidth;
  bool isGreaterThan(double screenWidth) => screenWidth >= maxWidth;

  static ScreenSize getScreenSize(double screenWidth) {
    if (ScreenSize.compact.isSmallerThan(screenWidth)) {
      return ScreenSize.compact;
    } else if (ScreenSize.medium.isSmallerThan(screenWidth)) {
      return ScreenSize.medium;
    } else if (ScreenSize.expanded.isSmallerThan(screenWidth)) {
      return ScreenSize.expanded;
    } else {
      return ScreenSize.large;
    }
  }
}

main() {
  WidgetsBinding.instance.platformDispatcher.onAccessibilityFeaturesChanged =
      () {
    print('reduceMotion: ');
  };

  runApp(const MyResponsiveApp());
}

class MyResponsiveApp extends StatelessWidget {
  const MyResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Layout with Strategies',
      home: ResponsiveLayout(
        compactLayoutStrategy: CompactLayoutStrategy(),
        mediumLayoutStrategy: MediumLayoutStrategy(),
        expandedLayoutStrategy: ExpandedLayoutStrategy(),
        largeLayoutStrategy: LargeLayoutStrategy(),
      ),
    );
  }
}

abstract class LayoutStrategy {
  Widget build(BuildContext context);
}

class CompactLayoutStrategy implements LayoutStrategy {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.portrait
        ? const Text('MobilePortraitLayout')
        : const Text('MobileLandscapeLayout');
  }
}

class MediumLayoutStrategy implements LayoutStrategy {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('MediumLayoutStrategy'),
    );
  }
}

class ExpandedLayoutStrategy implements LayoutStrategy {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('ExpandedLayoutStrategy'),
    );
  }
}

class LargeLayoutStrategy implements LayoutStrategy {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('LargeLayoutStrategy'),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final LayoutStrategy compactLayoutStrategy;
  final LayoutStrategy mediumLayoutStrategy;
  final LayoutStrategy expandedLayoutStrategy;
  final LayoutStrategy largeLayoutStrategy;

  const ResponsiveLayout({
    super.key,
    required this.compactLayoutStrategy,
    required this.mediumLayoutStrategy,
    required this.expandedLayoutStrategy,
    required this.largeLayoutStrategy,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final layoutStrategy = _getLayoutStrategy(constraints.maxWidth);
        return layoutStrategy.build(context);
      },
    );
  }

  LayoutStrategy _getLayoutStrategy(double width) {
    final screenSize = ScreenSize.getScreenSize(width);

    switch (screenSize) {
      case ScreenSize.compact:
        return compactLayoutStrategy;
      case ScreenSize.medium:
        return mediumLayoutStrategy;
      case ScreenSize.expanded:
        return expandedLayoutStrategy;
      case ScreenSize.large:
        return largeLayoutStrategy;
    }
  }
}

class MyCustomLayout extends StatelessWidget {
  const MyCustomLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: MyCustomDelegate(),
      child: Container(color: Colors.blue),
    );
  }
}

class MyCustomDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Custom constraints for the child
    return constraints;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Position child at the bottom-right corner
    return Offset(size.width - childSize.width, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(MyCustomDelegate oldDelegate) => false;
}

class MySingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Modify child constraints based on parent's constraints
    return BoxConstraints.tight(const Size(100, 100));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Position child in the center of the parent
    return Offset(size.width / 2 - childSize.width / 2,
        size.height / 2 - childSize.height / 2);
  }

  @override
  bool shouldRelayout(MySingleChildLayoutDelegate oldDelegate) => false;
}

class MyComplexLayout extends StatelessWidget {
  const MyComplexLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: MyComplexLayoutDelegate(),
      children: <Widget>[
        LayoutId(
          id: 'first',
          child: Container(color: Colors.red, width: 100, height: 100),
        ),
        LayoutId(
          id: 'second',
          child: Container(color: Colors.green, width: 100, height: 100),
        ),
      ],
    );
  }
}

class MyComplexLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    // Position 'first' widget
    layoutChild('first', BoxConstraints.loose(size));
    positionChild('first', Offset.zero);

    // Position 'second' widget to the right of 'first'
    if (hasChild('second')) {
      Size firstSize = layoutChild('first', BoxConstraints.loose(size));
      layoutChild('second', BoxConstraints.loose(size));
      positionChild('second', Offset(firstSize.width, 0));
    }
  }

  @override
  bool shouldRelayout(MyComplexLayoutDelegate oldDelegate) => false;
}

class ResponsiveChips extends StatelessWidget {
  final List<String> options;

  const ResponsiveChips({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      direction: Axis.horizontal,
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: options.map((option) => Chip(label: Text(option))).toList(),
    );
  }
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: List.generate(20, (index) {
                return Center(
                  child: Text(
                    'Item $index',
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
