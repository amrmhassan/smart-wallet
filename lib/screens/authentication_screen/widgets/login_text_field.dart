// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/sizes.dart';
import '../../../constants/theme_constants.dart';
import '../../../providers/theme_provider.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enableSuggestions;

  const LoginTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enableSuggestions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: themeProvider
              .getThemeColor(ThemeColors.kMainColor)
              .withOpacity(0.9),
          fontWeight: FontWeight.bold,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          left: kDefaultPadding / 2,
          top: kDefaultPadding / 1.5,
          bottom: kDefaultPadding / 1.5,
          right: kDefaultPadding * 1.5,
        ),
      ),
    );
  }
}
