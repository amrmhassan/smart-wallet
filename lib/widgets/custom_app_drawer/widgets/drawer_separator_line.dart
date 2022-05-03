import 'package:flutter/material.dart';

import '../../global/line.dart';

class DrawerSeparatorLine extends StatelessWidget {
  const DrawerSeparatorLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
      widthFactor: 0.8,
      child: Line(
        lineType: LineType.horizontal,
        thickness: 2,
      ),
    );
  }
}
