import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class Line extends StatelessWidget {
  final LineType lineType;
  final Color? color;
  final double? thickness;
  final double? widthFactor;
  const Line({
    Key? key,
    required this.lineType,
    this.color,
    this.thickness,
    this.widthFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return widthFactor != null
        ? FractionallySizedBox(
            widthFactor: widthFactor ?? 1,
            child: Container(
              height: lineType == LineType.vertical
                  ? double.infinity
                  : thickness ?? 3,
              width: lineType == LineType.vertical
                  ? thickness ?? 3
                  : double.infinity,
              decoration: BoxDecoration(
                color: color ??
                    themeProvider
                        .getThemeColor(ThemeColors.kMainColor)
                        .withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          )
        : Container(
            height: lineType == LineType.vertical
                ? double.infinity
                : thickness ?? 3,
            width: lineType == LineType.vertical
                ? thickness ?? 3
                : double.infinity,
            decoration: BoxDecoration(
              color: color ??
                  themeProvider
                      .getThemeColor(ThemeColors.kMainColor)
                      .withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
          );
  }
}

enum LineType {
  vertical,
  horizontal,
}
