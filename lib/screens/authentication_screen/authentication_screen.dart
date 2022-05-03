// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/authentication_screen/widgets/authentication_form_holder.dart';
import 'package:smart_wallet/screens/authentication_screen/widgets/swap_authentication_button.dart';

//! the inkwell doesn't accept the click when clicking outside the stack , find a solution for this
enum AuthenticationType {
  logIn,
  signUp,
}

class AuthenticationScreen extends StatefulWidget {
  static const String routeName = '/authentication-screen';
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthenticationType activeAuthenticationType = AuthenticationType.logIn;
  void swapActiveAuthenticationType() {
    if (activeAuthenticationType == AuthenticationType.logIn) {
      setState(() {
        activeAuthenticationType = AuthenticationType.signUp;
      });
    } else {
      setState(() {
        activeAuthenticationType = AuthenticationType.logIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                themeProvider.currentTheme == Themes.basic
                    ? 'assets/images/loginBackground.png'
                    : 'assets/images/loginBackgroundDark.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activeAuthenticationType == AuthenticationType.signUp)
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                    child: Text(
                      'Have an account?',
                      style: themeProvider.getTextStyle(
                        ThemeTextStyles.kParagraphTextStyle,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: kDefaultPadding / 2,
              ),
              //* the authentication type swap button holder
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: SwapAuthenticationButton(
                  title: 'Log In',
                  swapActiveAuthenticationType: swapActiveAuthenticationType,
                  activeAuthenticationType: activeAuthenticationType,
                  show: activeAuthenticationType == AuthenticationType.signUp,
                ),
              ),
              //* this is the authentication type and the authentication form holder
              FractionallySizedBox(
                widthFactor: .8,
                child: Column(
                  children: [
                    Text(
                      activeAuthenticationType == AuthenticationType.logIn
                          ? 'Log In'
                          : 'Sign Up',
                      style: themeProvider.getTextStyle(
                        ThemeTextStyles.kExtraLargeHeadingTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    //* the authentication form
                    AuthenticationFormHolder(
                      authenticationType: activeAuthenticationType,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kDefaultPadding * 2,
              ),
              if (activeAuthenticationType == AuthenticationType.logIn)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                    child: Text(
                      'Have no accounts?',
                      style: themeProvider.getTextStyle(
                        ThemeTextStyles.kParagraphTextStyle,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: kDefaultPadding / 2,
              ),
              //* the authentication type swap button holder
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: SwapAuthenticationButton(
                  title: 'Register',
                  swapActiveAuthenticationType: swapActiveAuthenticationType,
                  activeAuthenticationType: activeAuthenticationType,
                  show: activeAuthenticationType == AuthenticationType.logIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
