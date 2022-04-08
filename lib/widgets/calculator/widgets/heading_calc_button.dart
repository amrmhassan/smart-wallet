import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/responsive.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/choose_color_theme.dart';

class HeadingCalcButton extends StatelessWidget {
  final IconData? iconData;
  final String? title;

  final Function(String value) calculate;
  const HeadingCalcButton({
    Key? key,
    this.title,
    this.iconData,
    required this.calculate,
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
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: ChooseColorTheme.kMainColor.withOpacity(0.2),
            blurRadius: 6,
          )
        ],
        borderRadius: BorderRadius.circular(
          1000,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            calculate('');
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
