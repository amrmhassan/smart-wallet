import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/sizes.dart';
import '../../providers/theme_provider.dart';
import '../../themes/choose_color_theme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomFloatingActionButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Positioned(
      bottom: kCustomBottomNavBarHeight + 10,
      right: 20,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            boxShadow: [
              themeProvider.getBoxShadow(ThemeBoxShadow.kCardHeavyBoxShadow)
            ],
            color: ChooseColorTheme.kMainColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                kDefaultBorderRadius * 5,
              ),
              topRight: Radius.circular(
                kDefaultBorderRadius * 5,
              ),
              bottomRight: Radius.circular(
                kDefaultBorderRadius * 5,
              ),
            )),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultHorizontalPadding / 1.5,
                vertical: kDefaultVerticalPadding / 1.2,
              ),
              child: Text(
                title,
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kSmallTextWhiteColorStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
