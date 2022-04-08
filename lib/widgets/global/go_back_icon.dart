import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/sizes.dart';
import '../../providers/theme_provider.dart';
import '../../themes/choose_color_theme.dart';

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
        color: Colors.white,
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
            color: ChooseColorTheme.kMainColor,
            size: kDefaultIconSize,
          ),
        ),
      ),
    );
  }
}
