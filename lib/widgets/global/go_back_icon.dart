import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../constants/sizes.dart';
import '../../providers/theme_provider.dart';

class GoBackIcon extends StatelessWidget {
  const GoBackIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kMainColor),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          themeProvider.getBoxShadow(ThemeBoxShadow.kDefaultBoxShadow)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color:
                themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
            size: kDefaultIconSize,
          ),
        ),
      ),
    );
  }
}
