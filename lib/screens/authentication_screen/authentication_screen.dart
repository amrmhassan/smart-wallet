// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/widgets/global/line.dart';

//! the inkwell doesn't accept the click when clicking outside the stack , find a solution for this
enum AuthenticationType {
  logIn,
  signUp,
}
const int _animationDuration = 300;

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

class SubmitFormButton extends StatelessWidget {
  final double width = 60;
  const SubmitFormButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Positioned(
      right: -width / 2,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: themeProvider.getThemeColor(ThemeColors.kButtonColor),
          border: Border.all(
            width: 1,
            color: themeProvider.getThemeColor(ThemeColors.kMainColor),
          ),
        ),
        child: Material(
          color: themeProvider.getThemeColor(ThemeColors.kButtonColor),
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              width: width,
              height: width,
              child: Icon(
                FontAwesomeIcons.arrowRight,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
