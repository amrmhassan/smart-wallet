// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/screens/authentication_screen/authentication_screen.dart';
import 'package:smart_wallet/screens/authentication_screen/widgets/authentication_form.dart';
import 'package:smart_wallet/screens/authentication_screen/widgets/submit_button_form.dart';

import '../../../constants/theme_constants.dart';
import '../../../providers/theme_provider.dart';

class AuthenticationFormHolder extends StatelessWidget {
  final AuthenticationType authenticationType;
  const AuthenticationFormHolder({
    Key? key,
    required this.authenticationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerRight,
      children: [
        Container(
          // height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color:
                themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 6,
                color: themeProvider
                    .getThemeColor(ThemeColors.kMainColor)
                    .withOpacity(.5),
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(1000),
              bottomRight: Radius.circular(1000),
            ),
          ),
          child: AuthenticationForm(authenticationType: authenticationType),
        ),
        SubmitFormButton(),
      ],
    );
  }
}
