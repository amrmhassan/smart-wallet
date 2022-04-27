import 'package:flutter/material.dart';
import 'package:smart_wallet/screens/intro_screen/widgets/dot.dart';

class PagesTracker extends StatelessWidget {
  final int count;
  final int activeIndex;
  const PagesTracker({
    Key? key,
    required this.activeIndex,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          count,
          (index) => Dot(
                active: index == activeIndex,
              )),
    );
  }
}
