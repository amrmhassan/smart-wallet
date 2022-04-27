// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/theme_constants.dart';
import '../../../providers/theme_provider.dart';

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
          color: themeProvider.getThemeColor(ThemeColors.kActiveButtonColor),
          border: Border.all(
            width: 2,
            color: themeProvider.getThemeColor(ThemeColors.kMainColor),
          ),
        ),
        child: Material(
          color: themeProvider.getThemeColor(ThemeColors.kActiveButtonColor),
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
