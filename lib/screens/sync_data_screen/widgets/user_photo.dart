// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class UserPhoto extends StatelessWidget {
  final double? raduis;
  final String photoUrl;

  const UserPhoto({
    Key? key,
    required this.photoUrl,
    this.raduis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kMainColor),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
        ),
        width: raduis ?? 80,
        height: raduis ?? 80,
        child: Image.network(
          photoUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
