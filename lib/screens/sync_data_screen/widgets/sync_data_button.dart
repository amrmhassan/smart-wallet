// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class SyncDataButton extends StatelessWidget {
  final VoidCallback onTap;

  const SyncDataButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: themeProvider.getThemeColor(ThemeColors.kButtonColor),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: Text(
                'Sync Data',
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kActivateProfileTextStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
