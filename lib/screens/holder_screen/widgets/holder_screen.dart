// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class AddElementButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddElementButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(kDefaultPadding / 2),
            child: Icon(
              Icons.add,
              color: themeProvider.getThemeColor(
                ThemeColors.kMainColor,
              ),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
