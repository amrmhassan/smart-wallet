import 'package:flutter/material.dart';

import '../../themes/choose_color_theme.dart';

class Line extends StatelessWidget {
  final LineType lineType;
  final Color? color;
  final double? thickness;
  const Line({
    Key? key,
    required this.lineType,
    this.color,
    this.thickness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: lineType == LineType.vertical ? double.infinity : thickness ?? 3,
      width: lineType == LineType.vertical ? thickness ?? 3 : double.infinity,
      decoration: BoxDecoration(
        color: color ?? ChooseColorTheme.kMainColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

enum LineType {
  vertical,
  horizontal,
}
