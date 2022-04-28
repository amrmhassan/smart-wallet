// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/durations.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';

class CustomButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final String title;
  final double borderRadius;
  final double height;
  final Duration? duration;
  final Color? backgroundColor;

  const CustomButton({
    Key? key,
    this.active = true,
    required this.onTap,
    required this.title,
    this.borderRadius = kDefaultBorderRadius / 4,
    this.height = 100,
    this.duration,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedContainer(
      duration: duration ?? kAnimationsDuration,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: AnimatedContainer(
        duration: duration ?? kAnimationsDuration,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: active
              ? (backgroundColor ??
                  themeProvider.getThemeColor(ThemeColors.kActiveButtonColor))
              : (backgroundColor ??
                      themeProvider
                          .getThemeColor(ThemeColors.kActiveButtonColor))
                  .withOpacity(.3),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: active ? onTap : null,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: Text(
                title,
                style: active
                    ? themeProvider
                        .getTextStyle(ThemeTextStyles.kActiveButtonTextStyle)
                    : themeProvider
                        .getTextStyle(ThemeTextStyles.kInActiveButtonTextStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
