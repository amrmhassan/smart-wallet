// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/screens/authentication_screen/widgets/login_text_field.dart';

import '../../../constants/theme_constants.dart';
import '../../../providers/theme_provider.dart';
import '../../../widgets/global/line.dart';
import '../authentication_screen.dart';

class AuthenticationForm extends StatelessWidget {
  final AuthenticationType authenticationType;
  const AuthenticationForm({
    Key? key,
    required this.authenticationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Form(
        child: Column(
      children: [
        LoginTextField(
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        Line(
          lineType: LineType.horizontal,
          color: themeProvider
              .getThemeColor(ThemeColors.kMainColor)
              .withOpacity(0.2),
          thickness: 1.5,
        ),
        LoginTextField(
          hintText: 'Password',
          keyboardType: TextInputType.text,
          obscureText: true,
          enableSuggestions: false,
        ),
        if (authenticationType == AuthenticationType.signUp)
          Line(
            lineType: LineType.horizontal,
            color: themeProvider
                .getThemeColor(ThemeColors.kMainColor)
                .withOpacity(0.2),
            thickness: 1.5,
          ),
        if (authenticationType == AuthenticationType.signUp)
          LoginTextField(
            hintText: 'Confirm Password',
            keyboardType: TextInputType.text,
            obscureText: true,
            enableSuggestions: false,
          ),
      ],
    ));
  }
}
