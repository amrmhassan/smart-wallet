import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/responsive.dart';
import '../../../providers/theme_provider.dart';

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
        color: themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
        boxShadow: [
          themeProvider.getBoxShadow(ThemeBoxShadow.kDefaultBoxShadow)
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
                    color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                    size: kMediumIconSize,
                  ),
          ),
        ),
      ),
    );
  }
}
