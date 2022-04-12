// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/authentication_screen/authentication_screen.dart';

import '../../../constants/sizes.dart';

const int _animationDuration = 300;

class SwapAuthenticationButton extends StatelessWidget {
  final AuthenticationType activeAuthenticationType;
  final VoidCallback swapActiveAuthenticationType;
  final String title;
  final bool show;

  const SwapAuthenticationButton({
    Key? key,
    required this.activeAuthenticationType,
    required this.swapActiveAuthenticationType,
    required this.title,
    required this.show,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      width: show ? 130 : 0,
      duration: Duration(milliseconds: _animationDuration),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
        borderRadius: activeAuthenticationType == AuthenticationType.logIn
            ? BorderRadius.only(
                topRight: Radius.circular(1000),
                bottomRight: Radius.circular(1000),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(1000),
                bottomLeft: Radius.circular(1000),
              ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            color: themeProvider
                .getThemeColor(ThemeColors.kMainColor)
                .withOpacity(.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: swapActiveAuthenticationType,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
              vertical: kDefaultVerticalPadding,
            ),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: themeProvider
                  .getTextStyle(ThemeTextStyles.kMediumTextPrimaryColorStyle),
            ),
          ),
        ),
      ),
    );
  }
}
