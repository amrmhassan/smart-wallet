import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../../constants/sizes.dart';

const double width = 30;
const double height = 30;
const double borderRadius = 10;

class SummaryPeriodIcon extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;
  final bool enabled;

  const SummaryPeriodIcon({
    Key? key,
    required this.title,
    this.active = false,
    required this.onTap,
    this.enabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    Color kIconColor() {
      if (enabled) {
        if (active) {
          return Colors.white;
        } else {
          return themeProvider
              .getThemeColor(ThemeColors.kMainColor)
              .withOpacity(0.3);
        }
      } else {
        return themeProvider
            .getThemeColor(ThemeColors.kInactiveColor)
            .withOpacity(0.3);
      }
    }

    Color kBackgroundColor() {
      if (enabled) {
        if (active) {
          return themeProvider.getThemeColor(ThemeColors.kButtonColor);
        } else {
          return themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor);
        }
      } else {
        return themeProvider
            .getThemeColor(ThemeColors.kInactiveColor)
            .withOpacity(0.0);
      }
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kBackgroundColor(),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: Text(
              title,
              style: TextStyle(
                color: kIconColor(),
                fontSize: kDefaultInfoTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
