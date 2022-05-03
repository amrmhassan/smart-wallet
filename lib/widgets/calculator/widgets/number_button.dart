import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/responsive.dart';

class NumberButton extends StatelessWidget {
  final String number;
  final Function(String value) calculate;

  const NumberButton({
    Key? key,
    required this.calculate,
    required this.number,
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
        boxShadow: [themeProvider.getBoxShadow(ThemeBoxShadow.kIconBoxShadow)],
        borderRadius: BorderRadius.circular(
          kDefaultBorderRadius / 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            calculate(number);
          },
          child: Container(
              alignment: Alignment.center,
              child: Text(
                number,
                style:
                    themeProvider.getTextStyle(ThemeTextStyles.kCalcTextStyle),
              )),
        ),
      ),
    );
  }
}
