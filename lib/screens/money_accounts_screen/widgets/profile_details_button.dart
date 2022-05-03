import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';

class ProfileDetailsButton extends StatelessWidget {
  final String profileId;
  final VoidCallback onTap;
  const ProfileDetailsButton({
    Key? key,
    required this.profileId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: themeProvider
                .getThemeColor(ThemeColors.kInactiveColor)
                .withOpacity(.2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                  vertical: kDefaultPadding / 5,
                ),
                child: Row(
                  children: [
                    // Text(
                    //   'Details',
                    //   style: themeProvider.getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
                    // ),
                    Icon(
                      Icons.keyboard_double_arrow_right_outlined,
                      color:
                          themeProvider.getThemeColor(ThemeColors.kMainColor),
                      size: kMediumIconSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
