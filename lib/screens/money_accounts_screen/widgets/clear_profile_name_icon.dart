import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class ClearProfileNameIcon extends StatelessWidget {
  final VoidCallback onTap;
  const ClearProfileNameIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(
            right: kDefaultPadding / 4,
          ),
          decoration: BoxDecoration(
            color:
                themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
            borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: themeProvider.getThemeColor(ThemeColors.kDeleteColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
