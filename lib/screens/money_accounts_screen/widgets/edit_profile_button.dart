import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../../constants/sizes.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onTap;
  const EditProfileButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: themeProvider
            .getThemeColor(ThemeColors.kInactiveColor)
            .withOpacity(.2),
        borderRadius: BorderRadius.circular(
          kDefaultBorderRadius,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.edit,
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              size: kSmallIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
