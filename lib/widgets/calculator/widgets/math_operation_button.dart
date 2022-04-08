import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/choose_color_theme.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/responsive.dart';

import '../calculator.dart';

class MathOperationBtn extends StatelessWidget {
  final IconData? iconData;
  final String? title;
  final Operations operation;

  final Function(Operations value) setOperation;

  const MathOperationBtn({
    Key? key,
    this.title,
    this.iconData,
    required this.setOperation,
    required this.operation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      width: Responsive.getWidth(context) / 7,
      height: Responsive.getWidth(context) / 7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          1000,
        ),
        border: Border.all(width: 1, color: ChooseColorTheme.kMainColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setOperation(operation);
          },
          child: Container(
            alignment: Alignment.center,
            child: iconData == null
                ? Text(
                    title as String,
                    style: themeProvider
                        .getTextStyle(ThemeTextStyles.kCalcTextStyle),
                  )
                : Icon(
                    iconData,
                    color: ChooseColorTheme.kMainColor,
                    size: kMediumIconSize,
                  ),
          ),
        ),
      ),
    );
  }
}
