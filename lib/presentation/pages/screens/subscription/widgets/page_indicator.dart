import 'package:flutter/material.dart';
import 'package:morphzing/utils/style/colors.dart';

class PageIndicator extends StatefulWidget {
  final ValueNotifier<int> currentPageNotifier;
  final int itemCount;

  const PageIndicator({
    Key? key,
    required this.currentPageNotifier,
    required this.itemCount,
  }) : super(key: key);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    _readCurrentPageIndex();
    widget.currentPageNotifier.addListener(_handlePageIndex);

    super.initState();
  }

  @override
  void dispose() {
    widget.currentPageNotifier.removeListener(_handlePageIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.currentPageNotifier.addListener(_handlePageIndex);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.itemCount, (int index) {
          Color color = isDark ? darkBorderColor : dividerColor;
          double indicatorWidth = 5.0;
          if (isSelected(index)) {
            color = isDark ? Colors.white : greyTextColor;
            indicatorWidth = 15.0;
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: indicatorWidth,
            height: 5,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(100)),
          );
        }));
  }

  bool isSelected(int indicatorIndex) => _currentPageIndex == indicatorIndex;

  _handlePageIndex() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _currentPageIndex = widget.currentPageNotifier.value;
  }
}
