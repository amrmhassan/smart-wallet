// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../constants/sizes.dart';
import '../../constants/styles.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Clip? clipBehavior;
  final DecorationImage? backgroundImage;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;

  const CustomCard({
    Key? key,
    required this.child,
    this.clipBehavior,
    this.backgroundImage,
    this.height,
    this.padding,
    this.margin,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding,
          ),
      margin: margin,
      constraints: constraints,
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
        boxShadow:
            themeProvider.currentTheme == Themes.dark ? null : [kCardBoxShadow],
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        image: backgroundImage,
      ),
      child: child,
    );
  }
}
