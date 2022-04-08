import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../themes/choose_color_theme.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class ChooseTransactionTypeButton extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const ChooseTransactionTypeButton({
    Key? key,
    required this.title,
    this.active = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding / 1.5,
          vertical: kDefaultVerticalPadding / 3,
        ),
        decoration: BoxDecoration(
          color: active ? ChooseColorTheme.kMainColor : Colors.white,
          borderRadius: BorderRadius.circular(
            kDefaultBorderRadius,
          ),
          border: Border.all(
            width: 1.5,
            color: ChooseColorTheme.kMainColor,
          ),
        ),
        child: Text(
          title,
          style: active
              ? themeProvider
                  .getTextStyle(ThemeTextStyles.kSmallTextWhiteColorStyle)
              : themeProvider
                  .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
        ),
      ),
    );
  }
}
