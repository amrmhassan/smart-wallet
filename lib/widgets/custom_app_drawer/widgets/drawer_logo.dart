import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';

class DrawerLogo extends StatelessWidget {
  const DrawerLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.asset(
            'assets/images/whiteLogo-min.png',
            width: 200,
            fit: BoxFit.contain,
          ),
          Text(
            'Smart Wallet',
            style: TextStyle(
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
