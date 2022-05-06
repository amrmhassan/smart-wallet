// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../constants/sizes.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Clip? clipBehavior;
  final DecorationImage? backgroundImage;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final Color? splashColor;
  final Color? highlightColor;

  const CustomCard({
    Key? key,
    required this.child,
    this.clipBehavior,
    this.backgroundImage,
    this.height,
    this.padding,
    this.margin,
    this.constraints,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.onTap,
    this.splashColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ??
            themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
        boxShadow: themeProvider.currentTheme == Themes.dark
            ? null
            : [themeProvider.getBoxShadow(ThemeBoxShadow.kCardBoxShadow)],
        borderRadius:
            borderRadius ?? BorderRadius.circular(kDefaultBorderRadius),
        image: backgroundImage,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          onTap: onTap,
          child: Container(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: kDefaultHorizontalPadding,
                  vertical: kDefaultVerticalPadding,
                ),
            constraints: constraints,
            width: double.infinity,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  }
}
