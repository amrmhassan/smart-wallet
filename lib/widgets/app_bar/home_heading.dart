import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class HomeHeading extends StatelessWidget {
  final String title;
  const HomeHeading({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        style: themeProvider.getTextStyle(ThemeTextStyles.kHeadingTextStyle),
      ),
    );
  }
}
