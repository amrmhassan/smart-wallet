import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../constants/sizes.dart';

class PersonIcon extends StatelessWidget {
  final VoidCallback onTap;
  const PersonIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.person,
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              size: kDefaultIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
