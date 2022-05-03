import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';

class DrawerlistItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String title;
  final Color? color;

  const DrawerlistItem({
    Key? key,
    required this.iconData,
    required this.onTap,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding / 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: color ??
                    themeProvider.getThemeColor(ThemeColors.kMainColor),
                size: kDefaultIconSize,
              ),
              const SizedBox(
                width: kDefaultPadding / 2,
              ),
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
