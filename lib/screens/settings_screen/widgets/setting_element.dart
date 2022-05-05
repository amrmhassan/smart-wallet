// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class SettingElement extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String? title;
  final String? value;
  const SettingElement({
    Key? key,
    required this.onTap,
    required this.iconPath,
    this.value,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  width: 30,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  width: kDefaultPadding / 2,
                ),
                if (title != null)
                  Expanded(
                    child: Text(
                      title.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            themeProvider.getThemeColor(ThemeColors.kMainColor),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: kDefaultPadding / 2,
            ),
            Expanded(
              child: Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: themeProvider
                        .getThemeColor(ThemeColors.kMainColor)
                        .withOpacity(0.5),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
